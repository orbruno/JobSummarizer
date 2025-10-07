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
from .models.adapted_cv import AdaptedCVRequest

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
            employmentRecord={ # type: ignore
                "employer": request.employmentRecord.property_company,
                "description": request.employmentRecord.property_company_description,
                "property_job_titles": request.employmentRecord.property_job_titles,
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




# New endpoint for WriteComprehensiveProfile using adapted CV
@app.post("/write-comprehensive-profile")
def write_comprehensive_profile(request: AdaptedCVRequest):
    try:
        # Convert adapted_cv to the format expected by BAML
        adapted_cv_data = []
        for employer in request.adapted_cv:
            adapted_cv_data.append({
                "employer": employer.employer,
                "description": employer.description,
                "positions": {
                    "title": employer.position.title,
                    "description": employer.position.description,
                    "responsibilities": employer.position.responsibilities
                }
            })

        # Convert company brand to dictionary
        company_brand_data = {
            "golden_circle": {
                "why": request.company_brand.golden_circle.why,
                "how": request.company_brand.golden_circle.how,
                "what": request.company_brand.golden_circle.what
            },
            "customer_segments": request.company_brand.customer_segments,
            "writing_examples": [
                {
                    "style": example.style,
                    "tone": example.tone,
                    "example": example.example
                }
                for example in request.company_brand.writing_examples
            ]
        }

        result = b.WriteProfessionalProfile(
            job_title=request.job_title,
            job_description=request.job_description,
            job_responsibilities=request.job_responsibilities,
            competencies_and_skills=request.competencies_and_skills, # type: ignore
            adaptedCV=adapted_cv_data,  # Changed from employmentRecord to adaptedCV
            company_brand=company_brand_data,  # New parameter
            recruiter_name=request.recruiter_name  # New parameter
        )

        # Wrap the string result in a JSON object
        return {
            "professional_profile": result,
            "status": "success"
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error writing comprehensive profile: {e}")
