from pydantic import BaseModel
from typing import List, Optional

class TimeSpanModel(BaseModel):
    start: str
    end: Optional[str] = None
    time_zone: Optional[str] = None

class ExperienceModel(BaseModel):
    role: str
    responsabilities: List[str]

class CompetencyModel(BaseModel):
    competency: str
    soft_skills: List[str]
    hard_skills: List[str]

class EmploymentRecordNestedModel(BaseModel):
    property_job_titles: List[str]
    property_time_span: Optional[str] = None  # Changed from TimeSpanModel to str
    property_company_description: str
    property_company: str
    notion_jobpage_parent_id: Optional[str] = None
    experiences: List[ExperienceModel]
    competencies_used: Optional[List[str]] = []
    technical_proficiencies_used: Optional[List[str]] = []

class AdjustResumeRequest(BaseModel):
    job_title: str
    job_description: str
    job_responsibilities: List[str]
    competencies_and_skills: List[CompetencyModel]
    employmentRecord: EmploymentRecordNestedModel
