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
