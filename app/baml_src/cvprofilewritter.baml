// Defining a data model.
class GoldenCircle {
  why string
  how string
  what CompanyService[]
}

class CompanyService {
  name string
  description string
}

class WritingExample {
  style string
  tone string
  example string
}

class CompanyBrand {
  golden_circle GoldenCircle
  customer_segments string[]
  writing_examples WritingExample[]
}
class CompetencyAndSkills {
	competency string @description(#"
Relevant competency for the job position based on the all the competencies listed in the applicants adapted CV experience across multiple employers.
"#)
	skills string[] @description(#"
A list of relevant skill related to the competency of current competency being analyzed. If the competency is related to soft skill, don't return anything. If the competency is related to hard skill, return a list of relevant hard skills such as programming languages, tools, frameworks, platforms, etc.
"#)
}

class CoverLetter {
	subject_line string @description(#"
Convey with one look what position you are applying for in one line
"#)
	salutation string @description(#"
The salutation should be formal and address the hiring manager or recruiter by name if possible. If the name is not known, a general greeting such as "Dear Hiring Manager" is acceptable.
"#)
	introduction_paragraph string @description(#"
The introduction should 3 or 4 lines and answer why the applicant is applying for the position and how you became aware of it (through a friend, an employee at the company, a job portal, etc.). Be confident in your word choice. Don’t use insecure words such as ‘I think I would be a good fit’ but rather ‘I am confident that I will contribute to …’
	"#)
	teaser_paragraph string @description(#"
Paragraph of 5 or 6 lines to shine with the applicants skills, experience, and qualifications. Never just list things, but choose the relevant achievements and prove them with results. Don’t only refer to achievements in your work life, but if relevant, also mention efforts with private projects. This will show your personality, drive, and willingness to learn and grow beyond what you get paid for.
	"#)
	contribution_paragraph string @description(#"
Parragraph of 5 or 6 lines after the teaser paragraph where the applicant has showcased themselves, it is time to translate how these experiences and skills will contribute to the role and company. Convey that you have taken the time to research the company by referring to the company culture, possible awards the company has won, or projects that inspire and motivate you. Be authentic and confident.
	"#)
	closure_paragraph string @description(#"
Paragraph of 3 or 4 lines to close the cover letter:º
- Reemphasize your eagerness to join the company in the relevant position.
- Describe your future goals and the value you can bring to the company.
- Emphasize that you’d be happy to answer any questions via phone or in a personal interview.
"#)
}

class ProfileCoverLetterAndEmail {
  professional_profile string @description(#"
the purpose of the professional profile is to quickly convey to the hiring manager why the candidate is a strong match for the role and to entice them to read further into the CV. For that you must use the academic formations, and the professional experiences with the higher matching score from the adapted CV and use only the related competencies and skills from the job description to create a compelling summary that aligns with what the employer is looking for. The length should be between 90-120 words.
  "#)
  email_body string @description(#"
    write the body of an email to the hiring manager that introduces the candidate and expresses their interest in the job. The email should be concise and professional, and include a brief overview of the candidate's qualifications. It should also invite the hiring manager to review the attached CV and cover letter. The length should be between 100-150 words.
  "#)
	competencies_and_skills CompetencyAndSkills[] @description(#"
A list of eight top level competencies and skills that are relevant to the job position based on the all the competencies listed in the applicants adapted CV experience across multiple employers, also look into all the competences and skills from the non adapted CV. Include competencies and skills relevant to the job description first but if there are not enough, include other relevant competencies and skills from the adapted CV, giving priority to technical skills. Make sure to include core competencies related to data.
  "#)
	cover_letter  CoverLetter @description(#"
A structured, multi-paragraph cover letter (1 greeting line + 4 body paragraphs) in first person.
	"#)
}

class AdaptedPosition {
  title string
  description string
  responsibilities string[]
	competencies string[]
	technical_proficiencies string[]
}

class AdaptedEmployer {
  employer string
  description string
  positions AdaptedPosition
  matching_score string @description(#"
The matching score is a number between 1 and 7 in the linkbert scale that indicates how well the candidate's experience aligns with the job requirements. A higher score indicates a better match. Use the following scale to assign the matching score:
- 1 = Very poor match
- 2 = Poor match
- 3 = Fair match
- 4 = Good match
- 5 = Very good match
- 6 = Excellent match
- 7 = Perfect match
  "#)
  matching_reasons string @description(#"
The matching reasons provides a brief explanation of why the candidate received the assigned matching score.
"#)
}

class Specialization {
  focus string
  description string
}

class Formation {
  degree string
  institution string
  location string
  specializations Specialization[]
}

// Function to write a professional profile based on job description and adapted CV
function WriteProfessionalProfile(
  formations: Formation[],
  job_title: string,
  job_description: string,
  job_responsibilities: string[],
  all_competencies: string[],
	all_skills: string[],
	competencies_and_skills: Competency[],
  adaptedCV: AdaptedEmployer[],
  company_brand: CompanyBrand,
  recruiter_name: string) -> ProfileCoverLetterAndEmail {

  client "openai/gpt-4o-mini"
  prompt #"
    {{ _.role("system") }}
You are an expert IT recruiter specializing in data science and AI roles that will redact the supporting content to facilitate the job person selecting the best candidate. Your job is to create the a professional profile for a CV, the cover letter and email based on the provided job description, responsibilities, required competencies and skills, and the candidate's adapted CV experience across multiple employers.

You must understand the companies brand information including their mission, vision, services, target customer segments, and writing style examples to ensure the cover letter and email align with the company's tone and values.

Use a professional and engaging tone that reflects the company's brand voice. Ensure the content is concise

## Job title: {{ job_title }}

### Recruiters name: {{ recruiter_name }}

### Job Description: {{ job_description }}

### Job Responsibilities:
{% for responsibility in job_responsibilities %}
- {{ responsibility }}
{% endfor %}

### Required Job Competencies and Skills:
{% for competency in competencies_and_skills %}
- Competency: {{ competency.competency }}
  - Soft Skills:
  {% for skill in competency.soft_skills %}
    - {{ skill }}
  {% endfor %}
  - Hard Skills:
  {% for skill in competency.hard_skills %}
    - {{ skill }}
  {% endfor %}
{% endfor %}

## Company Brand Information:
### Company Mission & Vision (From Golden Circle):
- **Why (Purpose):** {{ company_brand.golden_circle.why }}
- **How (Process):** {{ company_brand.golden_circle.how }}
- **What (Services):**
{% for service in company_brand.golden_circle.what %}
  - **{{ service.name }}:** {{ service.description }}
{% endfor %}

### Target Customer Segments:
{% for segment in company_brand.customer_segments %}
- {{ segment }}
{% endfor %}

### Company Writing Style Examples:
{% for example in company_brand.writing_examples %}
- **{{ example.style }} & {{ example.tone }}:** "{{ example.example }}"
{% endfor %}

**IMPORTANT:** Use the company's writing style and tone as reference for the cover letter and professional profile. Align the content with their mission, values, and approach to work. Reference their specific services and customer focus where relevant. Avoid using filling words and big fancy phrases that don't communicate much and that dilute the message. When mentioning specific skills or experiences, be sure to provide context and relevance to the job at hand with an specific example of the outcome.

{{ ctx.output_format }}

{{ ChainOfThought() }}

{{ _.role("user")}}

Here is the candidate's adapted CV and the formations of the application so you can understand their experience across multiple employers and write the professional profile, cover letter and email accordingly:

## Job Experiences:
{% for employer in adaptedCV %}
### {{ employer.employer }}
- **Company Description:** {{ employer.description }}
- **Position:** {{ employer.positions.title }}
- **Main role:** {{ employer.positions.description }}
- **Competencies used in this position:**
{% for competency in employer.positions.competencies%}
	- {{ competency }}
{% endfor %}
- **Technical Proficiencies used in this position:**
{% for proficiency in employer.positions.technical_proficiencies%}
	- {{ proficiency }}
{% endfor %}
- **Key Responsibilities:**
  {% for responsibility in employer.positions.responsibilities %}
  - {{ responsibility }}
  {% endfor %}
- **Matching Score:** {{ employer.matching_score }} out of 7 because {{ employer.matching_reasons }}
---
{% endfor %}

## Formations:
{% for formation in formations %}
### {{ formation.degree }} - {{ formation.institution }} ({{ formation.location }})
- **Specializations:**
  {% for specialization in formation.specializations %}
  - **{{ specialization.focus }}:** {{ specialization.description }}
  {% endfor %}
---
{% endfor %}

## Competencies and Skills from the non adapted CV:
It might be possible that that not all the competencies and skills from the non adapted CV are represented in the adapted CV experience across multiple employers. Here is a list of all the competencies and skills from the non adapted CV that you can use to complement the professional profile, cover letter and email if needed:
{% for competency in all_competencies %}
- {{ competency }}
{% endfor %}
{% for skill in all_skills %}
- {{ skill }}
{% endfor %}
Based on this comprehensive work experience and the company brand information, write a professional profile, cover letter, and email that:
1. Synthesizes the most relevant skills and experiences that align with the target job requirements
2. Incorporates the company's mission, values, and approach
3. Uses appropriate tone and style consistent with the company's brand voice
4. References specific company services or focus areas where relevant to the candidate's experience

  "#
}

test job_fit {
  functions [WriteProfessionalProfile]
  args {
    job_title #"Senior Data Scientist (m/w/d)"#
    recruiter_name #"Alex Johnson"#
    job_description #"The role involves collaborative development with business partners using modern techniques including AI and applied statistics to achieve goals. Responsibilities include effective communication of analysis, advocating for data-driven decision-making, and developing scalable analysis models. The use of GenAI is mentioned as part of the modern techniques applied."#
    job_responsibilities [
      "Collaborate with business partners to develop new strategies using advanced data techniques",
      "Communicate complex analysis methods to stakeholders",
      "Advocate for and educate on data-driven decision-making",
      "Lead analytic approach integration with engineering and development teams",
      "Create scalable data models integrated with analytical products",
      "Develop new functions for combining diverse data sources",
      "Identify and develop long-term processes and standards within data science frameworks"
    ]
    competencies_and_skills [
      {
        "competency": "Data Science",
        "soft_skills": [
          "Communication",
          "Problem-solving"
        ],
        "hard_skills": [
          "Python (required)",
          "PySpark (required)",
          "Complex SQL Queries (required)",
          "Machine Learning (required)",
          "Azure (preferred)",
          "Databricks (preferred)",
          "Tableau (preferred)"
        ]
      },
      {
        competency: "Big Data Technologies",
        soft_skills: [
          "Not specified"
        ],
        hard_skills: [
          "Azure (preferred)",
          "Databricks (preferred)"
        ]
      },
      {
        competency: "Data Visualization",
        soft_skills: [
          "Not specified"
        ],
        hard_skills: [
          "Tableau (preferred)"
        ]
      }
    ]
    // ✅ Add formations
    formations [
      {
        "degree": "Master of Science in Cognitive Science",
        "institution": "University of Osnabrück",
        "location": "Osnabrück, Germany",
        "specializations": [
          {
            "focus": "Artificial Intelligence",
            "description": "Focused on probabilistic models, machine learning methods, and computational tools for deriving actionable insights."
          },
          {
            "focus": "Cognitive Psychology",
            "description": "Specialized in the mechanisms underlying human behavior, with a focus on Human-Computer Interaction (HCI)."
          }
        ]
      },
      {
        "degree": "Bachelor of Science in Sound Engineering",
        "institution": "Universidad de Costa Rica",
        "location": "San José, Costa Rica",
        "specializations": [
          {
            "focus": "Signal Processing and Acoustics",
            "description": "Focused on analyzing and modeling audio signals, with a strong mathematical foundation."
          },
          {
            "focus": "Sound Reinforcement and Mixing",
            "description": "Specialized in designing and operating sound reinforcement systems."
          }
        ]
      }
    ]
    // ✅ Add company_brand
    company_brand {
      golden_circle {
        why "To revolutionize data-driven decision making by making advanced analytics accessible to businesses of all sizes"
        how "Through innovative AI solutions and collaborative partnerships that transform complex data into actionable insights"
        what [
          {
            name "AI-Powered Analytics Platform"
            description "Scalable data science solutions that integrate seamlessly with existing business processes"
          },
          {
            name "Data Consulting Services"
            description "Expert guidance for implementing data-driven strategies and best practices"
          }
        ]
      }
      customer_segments [
        "Enterprise companies",
        "Growing startups",
        "Data-driven organizations"
      ]
      writing_examples [
        {
          style "Professional"
          tone "Innovative"
          example "We believe that every data point tells a story, and our mission is to help organizations discover those stories to drive meaningful change."
        },
        {
          style "Technical"
          tone "Authoritative"
          example "Our platform leverages state-of-the-art machine learning algorithms to deliver predictive insights with enterprise-grade reliability."
        }
      ]
    }
    adaptedCV [
      {
        "employer": "Decente Showtec",
        "description": "Decente Showtec is an events production and technical services company in Costa Rica, specializing in professional solutions for concerts, festivals, and large-scale cultural events. The company excels in stage management, sound, lighting, and logistics, ensuring high-quality execution for local and international productions.",
        "matching_score": "3",
        "matching_reasons": "The candidate has relevant experience in operations management and project execution, but lacks direct experience in data science and the specific technical skills required for the role.",
        "positions": {
          "title": "Chief of Operations",
          "description": "Managed operations at Decente Showtec, overseeing the coordination of logistics and resources for high-impact event productions, ensuring efficient workflows and quality execution.",
          "responsibilities": [
            "Took ownership of operations-critical projects to meet technical requirements for sound, lighting, and stage setups in line with event specifications.",
            "Transformed logistical data and resource management strategies into actionable solutions for seamless event production.",
            "Collaborated across multidisciplinary teams to innovate production processes and ensure effective execution.",
            "Optimized resource utilization and communication to enhance event interaction and delivery methodologies.",
            "Supervised project execution to maintain high standards of quality and efficiency, addressing challenges for flawless event outcomes."
          ],
					"competencies": [
						"Project Management",
						"Operations Management",
						"Team Leadership",
						"Logistics Coordination",
						"Event Production"
					],
					"technical_proficiencies": [
						"Project Management Software",
						"Event Management Tools",
						"Microsoft Office Suite"
					]
        }
      },
      {
        "employer": "Turri Creadores de Origen",
        "description": "Creadores de Origen is a digital marketplace connecting rural producers in Costa Rica with consumers, focusing on quality, origin, and sustainability, promoting transparent supply chains and meaningful relationships.",
        "matching_score": "6",
        "matching_reasons": "The candidate has strong experience in data science, including predictive modeling and statistical analysis, which directly aligns with the job requirements.",
        "positions": {
          "title": "Data Scientist",
          "description": "As a Data Scientist at Turri Creadores de Origen, the role involved utilizing data analysis and predictive modeling to enhance business strategies, customer interactions, and sustainability efforts.",
          "responsibilities": [
            "Developed and deployed Bayesian predictive models using R to transform user purchasing behavior data into actionable insights for business strategy optimization.",
            "Conducted advanced statistical analysis on data from BigQuery to deliver actionable intelligence on customer segmentation and LTV that guided marketing budget allocation.",
            "Collaborated across teams to pioneer a neuro-marketing analytics program, aligning user psychology insights with business strategies to optimize customer interaction and delivery methodologies.",
            "Lead data-driven decision making and project execution by enabling comprehensive business intelligence, providing clean, modeled data for self-service analytics tools."
          ],
					"competencies": [
						"Data Science",
						"Predictive Modeling",
						"Statistical Analysis",
						"Data Visualization",
						"Cross-functional Collaboration"
					],
					"technical_proficiencies": [
						"R",
						"BigQuery",
						"SQL",
						"Data Visualization Tools"
					]
        }
      }
    ]
		all_competencies [
			"Data Science",
			"Predictive Modeling",
			"Statistical Analysis",
			"Data Visualization",
			"Cross-functional Collaboration",
			"Project Management",
			"Operations Management",
			"Team Leadership",
			"Logistics Coordination",
			"Event Production"
		]
		all_skills [
			"Python",
			"PySpark",
			"Complex SQL Queries",
			"Machine Learning",
			"Azure",
			"Databricks",
			"Tableau",
			"R",
			"BigQuery",
			"SQL",
			"Data Visualization Tools",
			"Project Management Software",
			"Event Management Tools",
			"Microsoft Office Suite"
		]
  }
}
