from pydantic import BaseModel
from typing import List, Optional

class GoldenCircle(BaseModel):
    why: str
    how: str
    what: List[dict]  # List of CompanyService objects

class CompanyService(BaseModel):
    name: str
    description: str

class WritingExample(BaseModel):
    style: str
    tone: str
    example: str

class CompanyBrand(BaseModel):
    golden_circle: GoldenCircle
    customer_segments: List[str]
    writing_examples: List[WritingExample]

class AdaptedPosition(BaseModel):
    title: str
    description: str = None  # Made optional
    responsibilities: List[str]

class AdaptedEmployer(BaseModel):
    employer: str
    description: Optional[str] = None  # Made optional
    position: AdaptedPosition
    match_explanation: Optional[str] = None  # Add these fields that are coming from n8n
    match_index: Optional[int] = None

class AdaptedCVRequest(BaseModel):
    job_title: str
    job_description: str
    job_responsibilities: List[str]
    competencies_and_skills: List[dict]
    adapted_cv: List[AdaptedEmployer]
    company_brand: CompanyBrand  # New field
    recruiter_name: str  # New field
