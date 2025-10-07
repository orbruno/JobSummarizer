
class JobPosition {
  title string @description(#"
Return one job title (or a combined title if necessary) previously held by the individual that best aligns with the job being applied for, adapting from relevant past titles or responsibilities without copying the posting’s title or misrepresenting the role; if no relevant experience exists, return the closest position and mark it as (non-relevant).
  "#)
  description string @description(#"
A rewritten brief description of the job position and its responsibilities to better align with the job description being applied for, while still accurately reflecting the actual duties performed.
  "#)
  responsibilities string[] @description(#"
Return a list of rewritten responsibilities for the job title (or combined title, including roles from different positions held at the same company if relevant) that better align with the responsibilities in the job description, accurately reflecting tasks performed; replace non-relevant technologies with general terms or those in the description, keep and reframe mentioned technologies, and merge similar responsibilities into one encompassing statement.
"#)
}

class Competency {
  competency string @description(#"
The specific competency specified similar to the specifications of frameworks like ESCO or O*NET that the company is looking for in a candidate.
  "#)
  soft_skills string[] @description(#"
A list of soft skills relevant to the competency that the company is looking for in a candidate, normally including interpersonal skills, communication skills, or problem-solving abilities.
  "#)
  hard_skills string[] @description(#"
A list of hard skills or technical skills relevant to the competency that the company is looking for in a candidate, normally including specific tools, programming languages, or methodologies.
  "#)
}

// Input class - for receiving multiple positions
class EmploymentRecordInput {
  employer string @description(#"
The name of the company or organization where the individual was employed.
  "#)
  description string @description(#"
A brief description of what is the company or organization does or its main activities and focus areas.
  "#)
  property_job_titles string[] @description(#"
List of possible job titles that the candidate could use for this employment experience.
  "#)
  positions JobPosition[] @description(#"
All job positions held by the individual at the employer.
  "#)
}

class EmploymentRecord {
  employer string @description(#"
The name of the company or organization where the individual was employed.
  "#)
  description string @description(#"
A brief description of what is the company or organization does or its main activities and focus areas.
  "#)
  position JobPosition? @description(#"
Object describing the best matching job position held by the individual at the employer; the object captures the responsibilities and context that most closely align with the job requirements, allowing for a combination of multiple positions within the same company if necessary, and if no relevant experience exists, mark the closest position as (non-relevant).

  "#)
    match_explanation string? @description(#"
A brief explanation of how well the adjusted resume aligns with the job description and responsibilities, highlighting key areas of fit or gaps. This explanation should be used in the further match index evaluation that describes how well the adjusted resume experience matches the job description.
    "#)
    match_index int? @description(#"
An integer value from 1 to 7 indicating how well the adjusted resume matches the given job description.

Scale:
1 = Very poor match
2 = Poor match
3 = Fair match
4 = Good match
5 = Very good match
6 = Excellent match
7 = Perfect match

### Evaluation criteria:

Industry/sector alignment (highest weight):
- If the resume and job description are in the same or highly related industry, keep the base score.
- If they are in different industries/sectors, reduce the score by 2 points.
- If they are partially related (transferable industry experience, e.g. IT in healthcare vs IT in finance), reduce the score by 1 point.

Job alignment:
- Compare job titles, role descriptions, responsibilities, competencies, and skills between the resume and job description. Strong overlap increases the score.

Experience similarity:
- The closer the candidate's actual work experience is to the responsibilities in the job description, the higher the score. Significant differences or missing areas should reduce the score.

Final Score:
- After evaluating, apply any industry adjustment to produce the final integer (1–7 match_index).

### Output: Provide only the final integer (1–7), representing the match_index.
 "#)
}


function AdjustResume(job_title: string, job_description:string, job_responsibilities: string[], competencies_and_skills: Competency[], employmentRecord: EmploymentRecordInput) -> EmploymentRecord {

  client "openai/gpt-4o"
  prompt #"
    {{ _.role("system") }}
    You are an expert IT recruiter specializing in data science and AI roles. Your task is to review the job description, responsibilities and required competencies and skill and adjust the provided experienced to better match the job requirements from the following job description. Make sure not to invent any experience or skills that the candidate does not have. You can only rephrase or adjust the existing experience to better align with the job description.

    ## Job title:  {{ job_title }}
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

    Choose the job title from these options that best fits: {{ employmentRecord.property_job_titles | join(", ") }}.

    {{ ctx.output_format }}

    {{ ChainOfThought() }}

    {{ _.role("user")}}
    Analyze and adjust the following resume experience to better match the job description and responsibilities:

        ### Company: {{ employmentRecord.employer }}
      #### Company Description: {{ employmentRecord.description }}

    #### Available Job Title Options:
    {% for title in employmentRecord.property_job_titles %}
      - {{ title }}
    {% endfor %}

    #### All Positions at this Employer:
      {% for position in employmentRecord.positions %}
    ---
    ##### Title: {{ position.title }}
    - Description: {{ position.description }}
    - Responsibilities:
       {% for responsibility in position.responsibilities %}
      - {{ responsibility }}
      {% endfor %}

    {% endfor %}
  "#
}



// Test the function with a sample resume. Open the VSCode playground to run this.
test job_fit {
  functions [AdjustResume]
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
    employmentRecord {
      employer #"Turri Creadores de Origen"#
      description #"Turri is a pioneering e-commerce platform dedicated to empowering rural producers in Costa Rica. By connecting these artisans directly with consumers, Turri aims to foster sustainable economic growth and preserve cultural heritage. The platform offers a diverse range of products, from handmade crafts to organic food items."#
      property_job_titles [
				"Data Scientist",
				"AI Engineer",
				"Machine Learning Engineer",
				"Data Engineer",
				"Data Architect",
				"Full-Stack Developer",
				"Product Owner",
				"Project Manager",
				"UX/UI Designer",
				"Web Developer",
				"Cofounder"
			]
			positions [
          {
            "title": "UX/UI Designer and Web Developer",
            "description": "As a UX/UI Designer and Web Developer at Turri Creadores de Origen, I was responsible for creating a seamless and engaging user experience for our e-commerce platform. My role involved collaborating closely with cross-functional teams to translate user needs into intuitive designs and functional web applications.",
            "responsibilities": [
              "Spearheaded the end-to-end design and development of the Turri.cr e-commerce platform, from initial user research and Figma prototypes to full-stack implementation and deployment.",
              "Orchestrated the user experience strategy by conducting user research and synthesizing findings into intuitive, high-fidelity interfaces in Figma, leading to a 20% uplift in user engagement.",
              "Engineered a responsive and performant website using PHP, JavaScript, HTML5, and CSS3, implementing technical and on-page SEO best practices that resulted in achieving top-3 search engine rankings for multiple key terms.",
              "Architected a sophisticated analytics framework using Google Tag Manager and custom JavaScript event tracking, enabling detailed behavioral analysis that provided the data foundation for product and marketing strategies."
            ]
          },
          {
            "title": "Data Engineer/Data Architect",
            "description": "As a Data Engineer/Data Architect at Turri Creadores de Origen, I was responsible for designing and implementing the data infrastructure that supported our e-commerce platform. My role involved ensuring seamless data flow and accessibility across various systems.",
            "responsibilities": [
              "Designed and implemented a hybrid data platform architecture, orchestrating data flow between the headless PIM, WooCommerce, a GCS (Google Cloud Storage) Data Lake, and a BigQuery Data Warehouse.",
              "Led the definition and implementation of data governance and modeling standards as part of the overall data engineering strategy",
              "Implemented a multi-layered automation and ingestion strategy, selecting the optimal tool for each task:",
              "Built and maintained the core data transformation layer using dbt, developing tested, version-controlled SQL models to create a unified, 360-degree view of customer activity.",
              "Enabled comprehensive business intelligence by providing clean, modeled data to Looker and Metabase, empowering stakeholders with self-service analytics."
            ]
          },
          {
            "title": "Data Scientist",
            "description": "As a Data Scientist at Turri Creadores de Origen, I focused on leveraging data to drive business insights and inform strategic decisions.",
            "responsibilities": [
              "Developed and deployed Bayesian predictive models in R to forecast user purchasing behavior, allowing for robust quantification of uncertainty in sales funnels.",
              "Pioneered a neuro-marketing analytics program, designing and executing experiments to derive causal insights from user psychology and behavior, directly informing high-impact A/B tests and CRO (Conversion Rate Optimization) strategy.",
              "Containerized data science workflows using Docker, ensuring complete reproducibility for all analyses and model training environments from development through to production.",
              "Conducted advanced statistical analysis on modeled data from BigQuery, delivering actionable intelligence on customer segmentation and LTV (Lifetime Value) that guided marketing budget allocation."
            ]
          },
          {
            "title": "AI Engineer / Full-Stack Developer",
            "description": "As an AI Engineer / Full-Stack Developer at Turri Creadores de Origen, I was responsible for integrating AI technologies into our e-commerce platform to enhance user experience and operational efficiency.",
            "responsibilities": [
              "Architected a Headless PIM (Product Information Management)/CMS (Content Management System) using Supabase (PostgreSQL) as the central SSOT (Single Source of Truth) for product and content data.",
              "Developed a serverless content pipeline using Supabase Edge Functions to programmatically publish content from Notion directly into the Supabase SSOT, automating the editorial-to-production workflow.",
              "Engineered and deployed an AI-powered applications —including chatbots, report generators, and dashboards—to make internal knowledge accessible service with Docker to ensure a scalable, consistent, and isolated production environment.",
              "Built the integration layer that pushed data from the Supabase SSOT to the live WooCommerce e-commerce site, ensuring consistent and accurate product information for customers."
            ]
          },
          {
            "title": "Product Owner",
            "description": "As a Product Owner at Turri Creadores de Origen, I was responsible for defining and driving the product vision and strategy for our e-commerce platform. My role involved collaborating with cross-functional teams to ensure the successful delivery of high-quality products that met user needs and business objectives.",
            "responsibilities": [
              "Set product strategy and maximized ROI by defining the vision and roadmap, then building and prioritizing a backlog based on business value, user data, and Lean Startup experiments (A/B tests).",
              "Empowered a high-performing Scrum team by expertly facilitating all Agile ceremonies (Sprint Planning, Refinement, Reviews, and Retrospectives), ensuring the consistent delivery of high-quality product increments.",
              "Served as the Voice of the Customer by continuously engaging with rural producers and end-users to validate hypotheses, refine the Value Proposition Canvas, and ensure market fit.",
              "Drove end-to-end feature delivery, leading the launch of multiple MVPs (Minimum Viable Products) from user story mapping to analyzing post-release data for rapid iteration.",
              "Mastered cross-functional alignment by managing dependencies between front-end, back-end, and data/AI platform teams, ensuring seamless integration of all technical initiatives into a cohesive user experience.",
              "Championed data-informed decision making, establishing and tracking product KPIs (Key Performance Indicators) to provide transparent progress reports and make evidence-based adjustments to the product backlog."
            ]
          },
          {
            "title":  "Cofounder/Project Manager",
            "description": "As a Cofounder and Project Manager at Turri Creadores de Origen, I spearheaded the strategic vision and operational execution of our e-commerce platform dedicated to empowering rural producers in Costa Rica. My role encompassed securing non-dilutive funding through competitive grants, architecting the go-to-market strategy, and leading a cross-functional team to deliver a seamless user experience. I was instrumental in forging key partnerships with local businesses and academic institutions, driving both community adoption and R&D initiatives. Through agile methodologies and a customer-centric approach, I ensured the successful launch and sustained growth of Turri, aligning our mission with tangible business outcomes.",
            "responsibilities": [
              "Secured funds in non-dilutive funding by authoring and winning competitive grants from government agencies, providing the foundational capital for operational launch and sustained growth.",
              "Architected the company's GTM (Go-to-Market) strategy from the ground up, defining the business model, brand identity, and customer acquisition channels that led to acquiring the first 10 rural producers and 50 customers within the first year",
              "Directed the end-to-end product lifecycle of the Turri.cr eCommerce marketplace, translating user research and Lean Startup principles into a live platform. Implemented Agile practices to guide the development roadmap and ensure continuous value delivery.",
              "Recruited, hired, and led a cross-functional team of 10 students and 4 collaborators across engineering, design, and marketing, fostering a collaborative and values-driven culture focused on a unified mission.",
              "Forged and cultivated key strategic partnerships with local businesses and leading academic institutions, including Osnabrück University and the National University of Costa Rica, to bolster R&D, enhance credibility, and drive community adoption."
            ]
          }
        ]
    }
  }
}

