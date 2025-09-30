// Defining a data model.

class AdaptedPosition {
  title string
  description string
  responsibilities string[]
}

class AdaptedEmployer {
  employer string
  description string
  positions AdaptedPosition[]
}

// Function to write a professional profile based on job description and adapted CV
function WriteProfessionalProfile(job_title: string, job_description: string, job_responsibilities: string[], competencies_and_skills: Competency[], adaptedCV: AdaptedEmployer[]) -> string {

  client "openai/gpt-4o"
  prompt #"
    {{ _.role("system") }}
    You are an expert IT recruiter specializing in data science and AI roles. Your task is to write the professional profile paragraph (or CV summary) section of a CV to be a brief introduction that outlines the candidates attributes, qualities and work experiences that make them a great fit for the job they are applying for. The profile should be tailored to the specific job description, responsibilities, and required competencies and skills provided. Use a professional tone and ensure the profile is concise, clear, and highlights the most relevant aspects of the candidate's experience and skills. The length should be between 70-100 words.

    ## Job title: {{ job_title }}
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

    {{ ctx.output_format }}

    {{ ChainOfThought() }}

    {{ _.role("user")}}
    Here is the candidate's adapted CV experience across multiple employers:

    {% for employer in adaptedCV %}
    ### {{ employer.employer }}
    **Company Description:** {{ employer.description }}

    **Positions:**
    {% for position in employer.positions %}
    #### {{ position.title }}
    - **Description:** {{ position.description }}
    - **Key Responsibilities:**
    {% for responsibility in position.responsibilities %}
      - {{ responsibility }}
    {% endfor %}
    {% endfor %}

    ---
    {% endfor %}

    Based on this comprehensive work experience, write a professional profile that synthesizes the most relevant skills, experiences, and achievements that align with the target job requirements.


  "#
}

// Test the function with a sample resume. Open the VSCode playground to run this.
test job_fit {
  functions [WriteProfessionalProfile]
  args {
    job_title #"Senior Data Scientist (m/w/d)"#
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
    adaptedCV [
      {
        "employer": "Decente Showtec",
        "description": "Decente Showtec is an events production and technical services company in Costa Rica, specializing in professional solutions for concerts, festivals, and large-scale cultural events. The company excels in stage management, sound, lighting, and logistics, ensuring high-quality execution for local and international productions.",
        "positions": [
          {
            "title": "Chief of Operations",
            "description": "Managed operations at Decente Showtec, overseeing the coordination of logistics and resources for high-impact event productions, ensuring efficient workflows and quality execution.",
            "responsibilities": [
              "Took ownership of operations-critical projects to meet technical requirements for sound, lighting, and stage setups in line with event specifications.",
              "Transformed logistical data and resource management strategies into actionable solutions for seamless event production.",
              "Collaborated across multidisciplinary teams to innovate production processes and ensure effective execution.",
              "Optimized resource utilization and communication to enhance event interaction and delivery methodologies.",
              "Supervised project execution to maintain high standards of quality and efficiency, addressing challenges for flawless event outcomes."
            ]
          }
        ]
      },
      {
        "employer": "Turri Creadores de Origen",
        "description": "Creadores de Origen is a digital marketplace connecting rural producers in Costa Rica with consumers, focusing on quality, origin, and sustainability, promoting transparent supply chains and meaningful relationships.",
        "positions": [
          {
            "title": "Data Scientist",
            "description": "As a Data Scientist at Turri Creadores de Origen, the role involved utilizing data analysis and predictive modeling to enhance business strategies, customer interactions, and sustainability efforts.",
            "responsibilities": [
              "Developed and deployed Bayesian predictive models using R to transform user purchasing behavior data into actionable insights for business strategy optimization.",
              "Conducted advanced statistical analysis on data from BigQuery to deliver actionable intelligence on customer segmentation and LTV that guided marketing budget allocation.",
              "Collaborated across teams to pioneer a neuro-marketing analytics program, aligning user psychology insights with business strategies to optimize customer interaction and delivery methodologies.",
              "Lead data-driven decision making and project execution by enabling comprehensive business intelligence, providing clean, modeled data for self-service analytics tools."
            ]
          }
        ]
      }
    ]
  }
}
