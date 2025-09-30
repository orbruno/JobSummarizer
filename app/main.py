from fastapi import FastAPI, HTTPException
import nest_asyncio
import asyncio
from crawl4ai import AsyncWebCrawler
from baml_client.sync_client import b
from baml_client.types import JobPosting
from docling.document_converter import DocumentConverter
import tempfile

# Import models from the new models directory
from .models import JobRequest, AdjustResumeRequest
from .models.adapted_cv import AdaptedCVRequest, AdaptedEmployer

app = FastAPI()


@app.post("/generate-job-json")
def generate_job_json(request: JobRequest):
    nest_asyncio.apply()

    async def crawl_and_extract(url):
        async with AsyncWebCrawler() as crawler:
            result = await crawler.arun(url)
            html_content = result.html
            with tempfile.NamedTemporaryFile(
                delete=False, suffix=".html", mode="w", encoding="utf-8"
            ) as tmp:
                tmp.write(html_content)
                tmp_path = tmp.name

            converter = DocumentConverter()
            result_docling = converter.convert(tmp_path)
            doc_docling = result_docling.document
            job_post_md = doc_docling.export_to_markdown()

            return b.ExtractJobPosting(job_post_md)

    try:
        job_posting = asyncio.run(crawl_and_extract(request.url))
    except Exception as e:
        raise HTTPException(
            status_code=400, detail=f"Error crawling or extracting: {e}"
        )
    return job_posting


# Endpoint for AdjustResume
@app.post("/adjust-resume")
def adjust_resume(request: AdjustResumeRequest):
    try:
        result = b.AdjustResume(
            job_title=request.job_title,
            job_description=request.job_description,
            job_responsibilities=request.job_responsibilities,
            competencies_and_skills=[ # type: ignore
                {
                    "competency": c.competency,
                    "soft_skills": c.soft_skills,
                    "hard_skills": c.hard_skills,
                }
                for c in request.competencies_and_skills
            ],
            property_job_titles=request.employmentRecord.property_job_titles,
            employmentRecord={ # type: ignore
                "employer": request.employmentRecord.property_company,
                "description": request.employmentRecord.property_company_description,
                "positions": [
                    {
                        "title": exp.role.replace(':', '').strip(),
                        "description": f"{exp.role.replace(':', '').strip()} at {request.employmentRecord.property_company}",
                        "responsibilities": exp.responsabilities,
                    }
                    for exp in request.employmentRecord.experiences
                ],
            },
        )
        return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error adjusting resume: {e}")


# Endpoint for WriteProfessionalProfile using adapted CV
@app.post("/write-professional-profile")
def write_professional_profile(request: AdaptedCVRequest):
    try:
        # Process all employers from the adapted CV
        all_positions = []

        # Flatten all positions from all employers
        for employer in request.adapted_cv:
            for position in employer.positions:
                all_positions.append({
                    "title": position.title,
                    "description": position.description,
                    "responsibilities": position.responsibilities,
                    "employer": employer.employer
                })

        # Use the first employer as the main employment record for the BAML function
        # (You might want to modify this logic based on your needs)
        primary_employer = request.adapted_cv[0] if request.adapted_cv else None

        if not primary_employer:
            raise HTTPException(status_code=400, detail="No employment records found in adapted CV")

        result = b.WriteProfessionalProfile(
            job_title=request.job_title,
            job_description=request.job_description,
            job_responsibilities=request.job_responsibilities,
            competencies_and_skills=request.competencies_and_skills, # type: ignore
            employmentRecord={ # type: ignore
                "employer": primary_employer.employer,
                "description": primary_employer.description,
                "property_job_titles": [
                    {
                        "title": pos.title,
                        "description": pos.description,
                        "responsibilities": pos.responsibilities,
                    }
                    for pos in primary_employer.positions
                ],
            },
        )
        return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error writing professional profile: {e}")


# New endpoint for WriteComprehensiveProfile using adapted CV
@app.post("/write-comprehensive-profile")
def write_comprehensive_profile(request: AdaptedCVRequest):
    try:
        # Convert Pydantic models to dictionaries for BAML
        adapted_cv_data = []
        for employer in request.adapted_cv:
            employer_data = {
                "employer": employer.employer,
                "description": employer.description,
                "positions": [
                    {
                        "title": pos.title,
                        "description": pos.description,
                        "responsibilities": pos.responsibilities
                    }
                    for pos in employer.positions
                ]
            }
            adapted_cv_data.append(employer_data)

        result = b.WriteProfessionalProfile(
            job_title=request.job_title,
            job_description=request.job_description,
            job_responsibilities=request.job_responsibilities,
            competencies_and_skills=request.competencies_and_skills, # type: ignore
            adaptedCV=adapted_cv_data  # Changed from employmentRecord to adaptedCV
        )

        # Wrap the string result in a JSON object
        return {
            "professional_profile": result,
            "status": "success"
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error writing comprehensive profile: {e}")
