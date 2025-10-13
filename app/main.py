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
            job_requirements=request.job_requirements,
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
                        "competencies": exp.competencies_used,
                        "technical_proficiencies": exp.technical_proficiencies_used
                    }
                    for exp in request.employmentRecord.experiences
                ],
            },
        )
        return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error adjusting resume: {e}")


@app.post("/write-comprehensive-profile")
def write_comprehensive_profile(request: AdaptedCVRequest):
    try:
        # Convert adapted_cv to the format expected by BAML
        adapted_cv_data = []
        for employer in request.adapted_cv:
            adapted_cv_data.append({
                "employer": employer.employer,
                "description": employer.description,
                "matching_score": str(getattr(employer, 'match_index', 0)),  # ✅ Added matching_score
                "matching_reasons": getattr(employer, 'match_explanation', ''),  # ✅ Added matching_reasons
                "positions": {
                    "title": employer.position.title,
                    "description": employer.position.description,
                    "responsibilities": employer.position.responsibilities,
                    "competencies": employer.competencies,
                    "technical_proficiencies": employer.technical_proficiencies
                }
            })

        # Convert formations to the format expected by BAML
        formations_data = []
        for formation in request.formations:
            formations_data.append({
                "degree": formation.degree,
                "institution": formation.institution,
                "location": getattr(formation, 'location', ''),  # Handle missing location field
                "specializations": [
                    {
                        "focus": spec.specialization,
                        "description": spec.description or ''
                    }
                    for spec in formation.specializations
                ]
            })

        # Convert company brand to dictionary
        company_brand_data = {
            "golden_circle": {
                "why": request.company_brand.golden_circle.why,
                "how": request.company_brand.golden_circle.how,
                "what": [
                    {
                        "name": service.get("name", "") if isinstance(service, dict) else service.name,
                        "description": service.get("description", "") if isinstance(service, dict) else service.description
                    }
                    for service in request.company_brand.golden_circle.what
                ]
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

        # Convert competencies to the format expected by BAML
        competencies_data = []
        for comp in request.competencies_and_skills:
            if isinstance(comp, dict):
                competencies_data.append({
                    "competency": comp.get("competency", ""),
                    "soft_skills": comp.get("soft_skills", []),
                    "hard_skills": comp.get("hard_skills", [])
                })
            else:
                # Handle if it's already an object
                competencies_data.append({
                    "competency": getattr(comp, 'competency', ''),
                    "soft_skills": getattr(comp, 'soft_skills', []),
                    "hard_skills": getattr(comp, 'hard_skills', [])
                })

        result = b.WriteProfessionalProfile(
            formations=formations_data,
            job_title=request.job_title,
            job_description=request.job_description,
            job_responsibilities=request.job_responsibilities,
            competencies_and_skills=competencies_data,
            adaptedCV=adapted_cv_data,
            all_competencies=request.all_competencies,
						all_skills=request.all_skills,
            company_brand=company_brand_data,
            recruiter_name=request.recruiter_name
        )

        # Return the result from BAML (which should be a ProfileCoverLetterAndEmail object)
        return {
            "professional_profile": result.professional_profile,
            "competencies_and_skills": result.competencies_and_skills,
            "cover_letter": result.cover_letter,
            "email_body": result.email_body
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error writing comprehensive profile: {e}")
