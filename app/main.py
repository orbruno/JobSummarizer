from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
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
