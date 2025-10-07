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

class ProfileCoverLetterAndEmail {
	professional_profile string @description(#"
		write the professional profile paragraph (or CV summary) section of a CV to be a brief introduction that outlines the candidates attributes, qualities and work experiences that make them a great fit for the job they are applying for. The profile should be tailored to the specific job description, responsibilities, and required competencies and skills provided. Use a professional tone and ensure the profile is concise, clear, and highlights the most relevant aspects of the candidate's experience and skills. The length should be between 70-100 words.
	"#)
cover_letter string @description(#"
    Write a structured, multi-paragraph cover letter (1 greeting line + 4 body paragraphs) in first person that follows this exact format:

    **Greeting Line:** "Dear [Recruiter Name or Hiring Manager], I am writing to apply for the [Job Title] position."

    **Paragraph 1 - Who I Am & What I Believe In (2-3 sentences):**
    - Introduce yourself as a professional in your field
    - Mention your years of experience and key expertise
    - Connect to the company's mission/vision from their "why" statement

    **Paragraph 2 - Skill & Qualification Match (3 sentences using STAR format):**
    - Situation/Task: Describe a relevant project or role
    - Action/Result: Quantify your achievements and technical skills used
    - Demonstrate expertise in the required technical competencies

    **Paragraph 3 - Why I Want to Work Here (3 sentences):**
    - Reference the company's mission and how it aligns with your values
    - Mention their service model or approach that appeals to you
    - Express enthusiasm for contributing to their specific goals

    **Paragraph 4 - Conclusion & Thank You (3 sentences):**
    - Summarize why your background makes you a strong candidate
    - Express interest in discussing your qualifications further
    - Thank them for their time and consideration

    **Requirements:**
    - Use first-person voice throughout ("I am," "I have," "I believe")
    - Reference specific technical competencies and responsibilities from the job description
    - Incorporate the company's brand voice and mission
    - Separate paragraphs with exactly one blank line
    - Length: 200-300 words total
    - Do not mention language proficiency levels
    - Use professional, achievement-focused tone with quantified results where possible
"#)
	email_body string @description(#"
		write the body of an email to the hiring manager that introduces the candidate and expresses their interest in the job. The email should be concise and professional, and include a brief overview of the candidate's qualifications. It should also invite the hiring manager to review the attached CV and cover letter. The length should be between 100-150 words.
	"#)
}

class AdaptedPosition {
  title string
  description string
  responsibilities string[]
}

class AdaptedEmployer {
  employer string
  description string
  positions AdaptedPosition
}

// Function to write a professional profile based on job description and adapted CV
function WriteProfessionalProfile(
	job_title: string,
	job_description: string,
	job_responsibilities: string[],
	competencies_and_skills: Competency[],
	adaptedCV: AdaptedEmployer[],
	company_brand: CompanyBrand,
	recruiter_name: string) -> ProfileCoverLetterAndEmail {

  client "openai/gpt-4o"
  prompt #"
    {{ _.role("system") }}
    You are an expert IT recruiter specializing in data science and AI roles that will redact the supporting content to facilitate the job person selecting the best candidate. Your job is to create the a professional profile for a CV, the cover letter and email based on the provided job description, responsibilities, required competencies and skills, and the candidate's adapted CV experience across multiple employers.
		Understand the companies brand information including their mission, vision, services, target customer segments, and writing style examples to ensure the cover letter and email align with the company's tone and values.
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
    ### Company Mission & Vision:
    **Why (Purpose):** {{ company_brand.golden_circle.why }}
    **How (Process):** {{ company_brand.golden_circle.how }}

    **What (Services):**
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

    **IMPORTANT:** Use the company's writing style and tone as reference for the cover letter. Align the content with their mission, values, and approach to work. Reference their specific services and customer focus where relevant.

    {{ ctx.output_format }}

    {{ ChainOfThought() }}

    {{ _.role("user")}}
    Here is the candidate's adapted CV experience across multiple employers:

    {% for employer in adaptedCV %}
    ### {{ employer.employer }}
    **Company Description:** {{ employer.description }}

    **Position:**
    #### {{ employer.positions.title }}
    - **Description:** {{ employer.positions.description }}
    - **Key Responsibilities:**
    {% for responsibility in employer.positions.responsibilities %}
      - {{ responsibility }}
    {% endfor %}

    ---
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
    adaptedCV [
      {
        "employer": "Decente Showtec",
        "description": "Decente Showtec is an events production and technical services company in Costa Rica, specializing in professional solutions for concerts, festivals, and large-scale cultural events. The company excels in stage management, sound, lighting, and logistics, ensuring high-quality execution for local and international productions.",
        "positions": {
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
      },
      {
        "employer": "Turri Creadores de Origen",
        "description": "Creadores de Origen is a digital marketplace connecting rural producers in Costa Rica with consumers, focusing on quality, origin, and sustainability, promoting transparent supply chains and meaningful relationships.",
        "positions": {
          "title": "Data Scientist",
          "description": "As a Data Scientist at Turri Creadores de Origen, the role involved utilizing data analysis and predictive modeling to enhance business strategies, customer interactions, and sustainability efforts.",
          "responsibilities": [
            "Developed and deployed Bayesian predictive models using R to transform user purchasing behavior data into actionable insights for business strategy optimization.",
            "Conducted advanced statistical analysis on data from BigQuery to deliver actionable intelligence on customer segmentation and LTV that guided marketing budget allocation.",
            "Collaborated across teams to pioneer a neuro-marketing analytics program, aligning user psychology insights with business strategies to optimize customer interaction and delivery methodologies.",
            "Lead data-driven decision making and project execution by enabling comprehensive business intelligence, providing clean, modeled data for self-service analytics tools."
          ]
        }
      }
    ]

    company_brand {
      golden_circle {
        why "To empower businesses through data-driven insights and innovative solutions that drive growth and efficiency."
        how "By leveraging cutting-edge technologies and a customer-centric approach to deliver tailored data science services."
        what [
          { name: "Data Analytics", description: "Providing comprehensive data analysis to uncover trends and insights." },
          { name: "Machine Learning Solutions", description: "Developing predictive models to enhance decision-making processes." },
          { name: "Business Intelligence", description: "Creating dashboards and reports for real-time business monitoring." }
        ]
      }
      customer_segments [
        "Small to medium-sized enterprises (SMEs) looking to leverage data for growth",
        "Large corporations seeking advanced analytics and machine learning solutions",
        "Startups aiming to build data-driven products and services"
      ]
      writing_examples [
        { style: "Professional", tone: "Formal", example: "We are committed to delivering excellence through innovative solutions that meet our clients' unique needs." },
        { style: "Conversational", tone: "Friendly", example: "At our core, we believe in the power of data to transform businesses and drive success." }
      ]
    }
  }
}
