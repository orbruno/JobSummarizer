from pydantic import BaseModel
from typing import List, Optional


class AdaptedPosition(BaseModel):
    title: str
    description: str
    responsibilities: List[str]


class AdaptedEmployer(BaseModel):
    employer: str
    description: str
    positions: List[AdaptedPosition]
    match_explanation: str
    match_index: int


class AdaptedCVRequest(BaseModel):
    adapted_cv: List[AdaptedEmployer]
    job_title: str
    job_description: str
    job_responsibilities: List[str]
    competencies_and_skills: List[dict]  # Using dict for flexibility with competencies structure


class AdaptedCVOnly(BaseModel):
    """Model for just the adapted CV data without job information"""
    adapted_cv: List[AdaptedEmployer]
