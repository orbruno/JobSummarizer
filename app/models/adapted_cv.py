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
    competencies: Optional[List[str]] = []
    technical_proficiencies: Optional[List[str]] = []
    match_explanation: Optional[str] = None
    match_index: Optional[int] = None

class FormationSpecialization(BaseModel):
    specialization: str  # ✅ Changed from "name" to "specialization"
    description: Optional[str] = None

class ApplicantFormation(BaseModel):
    degree: str
    institution: str
    location: Optional[str] = None  # ✅ Added location field
    start_date: Optional[str] = None
    end_date: Optional[str] = None
    specializations: List[FormationSpecialization] = []  # ✅ Fixed indentation

class AdaptedCVRequest(BaseModel):
    job_title: str
    job_description: str
    job_responsibilities: List[str]
    competencies_and_skills: List[dict]
    adapted_cv: List[AdaptedEmployer]
    all_competencies: List[str]
    all_skills: List[str]
    company_brand: CompanyBrand
    recruiter_name: str
    formations: List[ApplicantFormation]
