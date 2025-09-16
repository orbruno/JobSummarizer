from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from typing import List, Optional
import nest_asyncio
import asyncio
from crawl4ai import AsyncWebCrawler
from baml_client.sync_client import b
from baml_client.types import JobPosting
from docling.document_converter import DocumentConverter
import tempfile


app = FastAPI()


class JobRequest(BaseModel):
    url: str


# Models for AdjustResume
class JobPositionModel(BaseModel):
    title: str
    description: str
    responsibilities: List[str]


class EmploymentRecordModel(BaseModel):
    employer: str
    description: str
    positions: List[JobPositionModel]


class CompetencyModel(BaseModel):
    competency: str
    soft_skills: List[str]
    hard_skills: List[str]


class AdjustResumeRequest(BaseModel):
    job_title: str
    job_description: str
    job_responsibilities: List[str]
    competencies_and_skills: List[CompetencyModel]
    employmentRecord: EmploymentRecordModel


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
            result_docling = converter.convert(
                tmp_path
            )  # Pass the file path, not the string
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


# New endpoint for AdjustResume
@app.post("/adjust-resume")
def adjust_resume(request: AdjustResumeRequest):
    try:
        result = b.AdjustResume(
            job_title=request.job_title,
            job_description=request.job_description,
            job_responsibilities=request.job_responsibilities,
            competencies_and_skills=[
                {
                    "competency": c.competency,
                    "soft_skills": c.soft_skills,
                    "hard_skills": c.hard_skills,
                }
                for c in request.competencies_and_skills
            ],
            employmentRecord={
                "employer": request.employmentRecord.employer,
                "description": request.employmentRecord.description,
                "positions": [
                    {
                        "title": p.title,
                        "description": p.description,
                        "responsibilities": p.responsibilities,
                    }
                    for p in request.employmentRecord.positions
                ],
            },
        )
        return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error adjusting resume: {e}")
