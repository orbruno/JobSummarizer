//Define data model for job postings.
class JobPosting {
  title string
  company string
  location string
  contract_details ContractDetails
  language_skills LanguageSkills
  description string @description(#"
    Write in one paragraph a summary of the job description. This will not be a comprehensive summary but a very short one that captures the essence of the job.
  "#)
  competencies_and_skills CompetenciesAndSkills[] @description(#"
    List the competencies and skills required or preferred for the job.
  "#)
  roles string[] @description(#"
    List the roles and responsibilities associated with the job focusing on the outcomes and deliverables expected from the role.
  "#)
	recruiter_details RecruiterDetails @description(#"
		If the job posting includes contact information for a recruiter or recruiting agency, extract the details here. If not mentioned return "Not specified" for each field.
	"#)
}

class CompetenciesAndSkills {
  competency string @description(#"
    Write one sentence that specifies the competency as frameworks like ESCO(European Skills, Competences, Qualifications and Occupations) or O*NET.
  "#)
  soft_skills string[] @description(#"
    List the soft skills associated with the competency. Examples include communication, teamwork, problem-solving, adaptability, time management, leadership, creativity, work ethic, interpersonal skills, conflict resolution, emotional intelligence, attention to detail, and critical thinking.
  "#)
  hard_skills string[] @description(#"
    List the hard skills associated with the competency. Examples include programming languages, specific modules or frameworks, software proficiency specific to the competency making sure that is not too broad that becomes a competency instead of a skill.
  "#)
}

class LanguageSkills {
  english_level string @description(#"
    Look for specific references to the english level in the job posting, if not mentioned and make return "Not specified". Only use C2 if explicitly stated in the job posting or if it says that is require a Native level.
    A1, A2, B1, B2, C1, C2
    "#)
  german_level string @description(#"
    Look for specific references to the german level in the job posting, if not mentioned return "Not specified". Only use C2 if explicitly stated in the job posting or if it says that is require a Native level.
    A1, A2, B1, B2, C1, C2
    "#)
  languages string @description(#"
    Mention the languages that are required or preferred for the job along with their proficiency levels if specified. If no languages are mentioned return the name of the language used in the scrapped posting.
    "#)
}

class ContractDetails {
  type string @description(#"
    Contract, Internship, Temporary, Volunteer, Apprenticeship
    "#)
  duration string @description(#"
    Duration of the contract if applicable (e.g., 6 months, 1 year)
    "#)
  time_commitment string @description(#"
    Full-time, Part-time, Shift-based, Flexible hours
    "#)
  work_mode string @description(#"
    Remote, On-site, Hybrid
    "#)
}
class RecruiterDetails {
  name string @description(#"
    Name of the recruiter or recruiting agency.
    "#)
  email string @description(#"
    Email address of the recruiter or recruiting agency.
    "#)
  phone string @description(#"
    Phone number of the recruiter or recruiting agency.
    "#)
}

// Function to extract job posting details from a string.
function ExtractJobPosting(posting: string) -> JobPosting {
    client "openai/gpt-4o" // Set OPEN
    prompt #"
    Extract from the following scraped job posting from a website using Crawl4AI and output as marked down.
    If the text is in another language than English, translate it to English first.
    Always write the output in English:
        {{ posting }}

        {{ ctx.output_format }}
    "#
}

// Test the function with a sample job posting. Open the VSCode playground to run this.
test sample_job_posting_no_language_skills {
  functions [ExtractJobPosting]
  args {
    posting #"""
[](https://www.stepstone.de/en)
Search
Sign in
Menu
Find Jobs
[![CEWE Stiftung & Co. KGaA logo](https://www.stepstone.de/upload_de/logo/B/logoCEWE-Stiftung-Co-KGaA-133558DE-2105311403.gif)](https://www.stepstone.de/cmp/en/CEWE-Stiftung-Co-KGaA-133558/work.html)
# KI Entwickler (m/w/d)
  * CEWE Stiftung & Co. KGaA
  * [Oldenburg](https://www.stepstone.de/jobs--KI-Entwickler-m-w-d-Oldenburg-CEWE-Stiftung-Co-KGaA--12933185-inline.html?rltr=24_24_25_seorl_m_0_0_0_0_0_0#location)
  * Permanent contract
  * Full Time, Home office possible, Part time
  * Published: 10 hours ago
  * Show salary


I'm interested
Save
[![CEWE Stiftung & Co. KGaA logo](https://www.stepstone.de/upload_de/logo/B/logoCEWE-Stiftung-Co-KGaA-133558DE-2105311403.gif)](https://www.stepstone.de/cmp/en/CEWE-Stiftung-Co-KGaA-133558/work.html)
**KI Entwickler (m/w/d)**[ CEWE Stiftung & Co. KGaA](https://www.stepstone.de/cmp/en/CEWE-Stiftung-Co-KGaA-133558/work.html)
I'm interested
Save
![loader](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20xmlns:xlink='http://www.w3.org/1999/xlink'%20width='852px'%20height='334px'%20viewBox='0%200%20852%20334'%3E%3Ctitle%3EHero-image-Desktop%3C/title%3E%3Cdefs%3E%3Cfilter%20id='filter-1'%3E%3CfeColorMatrix%20in='SourceGraphic'%20type='matrix'%20values='0%200%200%200%200.556863%200%200%200%200%200.592157%200%200%200%200%200.643137%200%200%200%201.000000%200'%3E%3C/feColorMatrix%3E%3C/filter%3E%3C/defs%3E%3Cg%20id='Page-1'%20stroke='none'%20stroke-width='1'%20fill='none'%20fill-rule='evenodd'%3E%3Cg%20id='CD-1769-D'%20transform='translate\(-150.000000,%20-539.000000\)'%3E%3Cg%20id='Hero-image-Desktop'%20transform='translate\(150.000000,%20539.000000\)'%3E%3Crect%20id='Mask'%20fill='%23F5F5F5'%20x='0'%20y='0'%20width='852'%20height='334'%3E%3C/rect%3E%3Cg%20id='_Common/icon/image/--48px'%20transform='translate\(414.000000,%20155.000000\)'%20filter='url\(%23filter-1\)'%3E%3Cg%3E%3Cpath%20d='M22.24,1.29674049e-13%20C23.2120212,1.29674049e-13%2024,0.78797884%2024,1.76%20L24,1.76%20L24,22.24%20C24,23.2120212%2023.2120212,24%2022.24,24%20L22.24,24%20L1.76,24%20C0.78797884,24%20-7.76267939e-13,23.2120212%20-7.76267939e-13,22.24%20L-7.76267939e-13,22.24%20L-7.76267939e-13,1.76%20C-7.76267939e-13,0.78797884%200.78797884,1.29674049e-13%201.76,1.29674049e-13%20L1.76,1.29674049e-13%20Z%20M22.755,19.445%20L20.5833595,19.4470352%20C20.5498111,19.4497574%2020.5163744,19.449709%2020.4833479,19.4470256%20L6.37389643,19.4457507%20C6.33516605,19.4497088%206.29596684,19.4500557%206.25683085,19.4466584%20L1.244,19.445%20L1.24444444,22.24%20C1.24444444,22.4930964%201.42682239,22.7035962%201.66732824,22.7472493%20L1.76,22.7555556%20L22.24,22.7555556%20C22.5247335,22.7555556%2022.7555556,22.5247335%2022.7555556,22.24%20L22.7555556,22.24%20L22.755,19.445%20Z%20M22.24,1.24444444%20L1.76,1.24444444%20C1.47526653,1.24444444%201.24444444,1.47526653%201.24444444,1.76%20L1.24444444,1.76%20L1.244,18.201%20L5.96,18.201%20L8.77887575,13.5051016%20C8.97727569,13.1741023%209.32374055,12.9597338%209.70849266,12.9299191%20C10.0451507,12.9038312%2010.3746131,13.0218714%2010.6171919,13.2503935%20L10.7156025,13.3549977%20L12.5127111,15.51232%20L15.9863575,10.302613%20C16.1842164,10.0051064%2016.5019182,9.81614769%2016.8483029,9.77816791%20L16.9793637,9.7710855%20L17.1120451,9.7786546%20C17.5114523,9.82383641%2017.8579057,10.0666924%2018.0388641,10.4206138%20L18.0928997,10.5425823%20L20.962,18.201%20L22.755,18.201%20L22.7555556,1.76%20C22.7555556,1.50690358%2022.5731776,1.29640381%2022.3326718,1.25275073%20L22.24,1.24444444%20Z%20M16.96384,11.07712%20L13.0866244,16.8962349%20C12.8751423,17.2134886%2012.4384041,17.2623159%2012.1619897,17.0221187%20L12.0908686,16.9494289%20L9.80679111,14.2091378%20L7.411,18.201%20L19.634,18.201%20L16.96384,11.07712%20Z%20M8.01777778,4.54769778%20C9.3039876,4.54769778%2010.3466667,5.59037685%2010.3466667,6.87658667%20C10.3466667,8.16279648%209.3039876,9.20547556%208.01777778,9.20547556%20C6.73156796,9.20547556%205.68888889,8.16279648%205.68888889,6.87658667%20C5.68888889,5.59037685%206.73156796,4.54769778%208.01777778,4.54769778%20Z%20M8.01777778,5.79214222%20C7.41885565,5.79214222%206.93333333,6.27766454%206.93333333,6.87658667%20C6.93333333,7.4755088%207.41885565,7.96103111%208.01777778,7.96103111%20C8.61669991,7.96103111%209.10222222,7.4755088%209.10222222,6.87658667%20C9.10222222,6.27766454%208.61669991,5.79214222%208.01777778,5.79214222%20Z'%20id='image'%20fill='%23566578'%3E%3C/path%3E%3C/g%3E%3C/g%3E%3C/g%3E%3C/g%3E%3C/g%3E%3C/svg%3E%0A)
![slide number 1](https://image-proxy.stepstone.com/live/image.jpg?url=https%3a%2f%2fkarriere.cewe.de%2fappo%2fpublic%2fmedia%2f07cffe1b-a9dd-4271-bff0-b0f73deee482%2fsmuMB961bDcJ7Wtob0QIFzutg3Gb1AXz7S0gMi7vhai.jpg&downsize=1140px%3A%2A&output-quality=85)
Wir bei CEWE schaffen Orte, an denen Kreativität auf Technologie trifft und emotionale Produkte unseren Alltag prägen. Wir stehen für Teamgeist, Innovation und Nachhaltigkeit – Werte, die in unserer Unternehmenskultur fest verankert sind. Vielfalt und ein wertschätzendes Miteinander sind für uns nicht nur Worte, sondern gelebte Praxis. Wir begrüßen und fördern individuelle Perspektiven, lehnen jede Form der Diskriminierung ab und setzen uns aktiv für ein inklusives Arbeitsumfeld ein – für ein Miteinander, das inspiriert, fördert und begeistert.
* * *
#### Die Aufgaben im Überblick:
Das Team MAIC (Mobile & Artificial Intelligence Campus) ist vom operativen Geschäft ausgenommen und in verschiedenen Forschungsfeldern aktiv. Es werden KI-basierte Lösungen entwickelt, um beispielsweise Bestell- und Gestaltungsprozesse für Kund:innen zu vereinfachen und zu bereichern. Unter anderem werden mit Hilfe von KI-Technologien die Fotoauswahlprozesse und die Produktgestaltung unterstützt.
  * **Neuronale Netze & Fotoanalyse**: Anwendung und Anpassung von neuronalen Netzen zur semantischen Analyse von Fotos, insbesondere mittels CNNs
  * **Generative KI-Technologien:** Evaluation und Adaption aktueller Technologien zur generativen Bilderzeugung
  * **KI-Trainingsprozesse:** Aufbau sowie eigenständige Durchführung und Optimierung von Trainingsprozessen für KI-Modelle
  * **Softwarebetrieb & Integration:** Betrieb von KI-basierten Softwarelösungen und deren Integration in bestehende Softwareplattformen bei CEWE


* * *
#### Unser Wunschprofil:
  * **Interesse & Eigeninitiative: **Ausgeprägtes Interesse und Eigeninitiative bei der Einarbeitung in Verfahren zur KI-basierten Bildanalyse und -manipulation
  * **Bildästhetik & Kreativität:** Starker Sinn für Bildästhetik sowie grundlegendes Interesse an künstlerischer Bildgestaltung
  * **KI-Modelle & Praxis:** Nachweisliche Erfahrung im Trainieren und Betreiben von KI-Modellen
  * **Zusammenarbeit & Team:** Hohe Teamfähigkeit und Freude an kollaborativem Arbeiten


* * *
#### Das macht uns bei CEWE aus:
Flexibilität & Work-Life-Balance: Flexible Arbeitszeitmodelle, mobiles Arbeiten bis zu 60% (positionsabhängig) sowie 30 Urlaubstage
Finanzielle Benefits: Betriebliche Altersvorsorge, Mitarbeiteraktienprogramm, Mitarbeiterrabatte etc.
Umfangreiche Weiterentwicklungsmöglichkeiten: Vielseitige Angebote aus Seminaren, Trainings und individuellen Entwicklungsmöglichkeiten, um beruflich und persönlich zu wachsen
Innovative & offene Unternehmenskultur mit jeder Menge Teamspirit: Wir bieten ein strukturiertes Onboarding sowie jährliche Highlights wie beispielsweise unser Sommerfest
Vielfalt & Verantwortung: Wir setzen auf Diversity, Inklusion und Nachhaltigkeit
Familienfreundlicher Arbeitgeber: Tagesbetreuung "cewelino" und Ferienbetreuungsprogramme direkt am Standort
Vielfältige Gesundheitsangebote: Hansefit, Fahrradleasing, psychosoziale Beratung, mobile Massagen und vieles mehr
Moderne Arbeitsumgebung: Neueste Ausstattung, höhenverstellbare Schreibtische und ein Betriebsrestaurant für die gemeinsame Mittagspause
* * *
#### Überzeugt?
* * *
I'm interested
* * *
#### Predicted salary
Curious about the salary for this job?Show salary
Chart icon
Min €Max €
* * *
Like this job?
close
* * *
[![Logo CEWE Stiftung & Co. KGaA](https://www.stepstone.de/upload_de/logo/B/logoCEWE-Stiftung-Co-KGaA-133558DE-2105311403.gif)](https://www.stepstone.de/cmp/en/CEWE-Stiftung-Co-KGaA-133558/work.html)
CEWE Stiftung & Co. KGaA
Sonstige Dienstleistungen • 2501-5000 Employees
136 Reviews
[6 Jobs](https://www.stepstone.de/cmp/en/CEWE-Stiftung-Co-KGaA-133558/work.html)Company Profile
* * *
#### Our Location
**CEWE Stiftung & Co. KGaA**Meerweg 30-32, 26133 Oldenburg, Deutschland
Open map
##### Commute Time
From:
To:
How:
Car Public Transport Walk Cycle
Show commute time
- - : - -
* * *
#### Company Benefits
Company Pension
Sports Activities
Flexible Working Hours
Company Laptop
Fitness Offers
Incentives and Events
Parking Space
Employee Discount
Cafeteria
Meal Coupons
Company Mobile Phone
Corporate Childcare
Company Medical Officer
Stock Options
Coaching Offers
Company Car
Good Transport Connections
The employee benefits shown are company-specific and may vary depending on the position and department.
### In Short
  * **Industry** Sonstige Dienstleistungen
  * **Founded**
  * **Location**
  * **Company size** 2501-5000


### About us
**Herzlich willkommen bei Europas führendem Fotoservice und innovativem Online-Druck Partner**
CEWE ist Europas führender Fotoservice und innovativer Online Druckpartner. Neben dem Qualitätsversprechen „Best in Print“ steht CEWE für Innovation und Freude am Foto. Mit seinen Markenprodukten, wie dem CEWE FOTOBUCH, CEWE CARDS, CEWE KALENDER und CEWE WANDBILDER sowie einer Vielfalt an Fotogeschenken bietet der Marktführer ein breites und qualitativ hochwertiges Sortiment im Fotofinishing. Das CEWE FOTOBUCH ist das beliebteste Fotobuch Europas, das 2018 6,18 Mio. Menschen die Möglichkeit gegeben hat, ihre persönlichen Geschichten zu erzählen und wieder zu erleben.
Neben dem Fotofinishing erschließt CEWE mit den Marken CEWE-PRINT.de, SAXOPRINT, Laserline und viaprinto den wachsenden Markt Online-Druck für kommerzielle Werbedrucksachen. Das Unternehmen ist mit 14 Betriebsstätten in 26 Ländern und rund 4.000 Mitarbeiterinnen und Mitarbeitern vertreten. Neben den Endkunden werden europaweit auch über 20.000 Handelspartner von CEWE beliefert.
Die Geschichte von CEWE beginnt 2012 mit der Eröffnung eines kleinen Fotostudios in Oldenburg durch Carl Wöltje. CEWE als Unternehmen wurde 1961 von dessen Schwiegervater Senator h. c. Heinz Neumüller gegründet und 1993 als Aktiengesellschaft an die Börse gebracht. Die CEWE Stiftung & Co. KGaA ist im SDAX gelistet und erzielte im Jahr 2018 einen Konzernumsatz von 653,3 Mio. Euro.
#### These jobs were popular with other job seekers
[![Nehlsen Business Service GmbH & Co. KG](https://www.stepstone.de/upload_de/logo/7/logoKarl-Nehlsen-GmbH-Co-KG-257101DE-2101280904.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/nehlsen-business-service-gmbh-co-kg-257101/work)
## [Data Engineer* (m/w/d)](https://www.stepstone.de/jobs--Data-Engineer-m-w-d-Bremen-Nehlsen-Business-Service-GmbH-Co-KG--12950599-inline.html)
Nehlsen Business Service GmbH & Co. KG
Bremen
Partially remote
1 week ago
[![TKMS ATLAS ELEKTRONIK GmbH](https://www.stepstone.de/upload_de/logo/A/logoATLAS-ELEKTRONIK-GmbH-6671DE.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/tkms-atlas-elektronik-gmbh-6671/work)
## [Softwareentwickler Klassifizierung (m/w/d)](https://www.stepstone.de/jobs--Softwareentwickler-Klassifizierung-m-w-d-Bremen-TKMS-ATLAS-ELEKTRONIK-GmbH--12940241-inline.html)
TKMS ATLAS ELEKTRONIK GmbH
Bremen
Partially remote
2 weeks ago
[![TKMS ATLAS ELEKTRONIK GmbH](https://www.stepstone.de/upload_de/logo/A/logoATLAS-ELEKTRONIK-GmbH-6671DE.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/tkms-atlas-elektronik-gmbh-6671/work)
## [Software Entwickler (m/w/d)](https://www.stepstone.de/jobs--Software-Entwickler-m-w-d-Bremen-TKMS-ATLAS-ELEKTRONIK-GmbH--12933027-inline.html)
TKMS ATLAS ELEKTRONIK GmbH
Bremen
Partially remote
19 hours ago
NEW
[![CompuGroup Medical Deutschland AG](https://www.stepstone.de/upload_de/logo/C/logoCompuGroup-Medical-SE-206929DE.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/compugroup-medical-deutschland-ag-206929/work)
## [Integration AI Developer (m/w/d)](https://www.stepstone.de/jobs--Integration-AI-Developer-m-w-d-Koblenz-Berlin-CompuGroup-Medical-Deutschland-AG--12932773-inline.html)
CompuGroup Medical Deutschland AG
Koblenz, Berlin
Partially remote
13 hours ago
NEW
[![TKMS ATLAS ELEKTRONIK GmbH](https://www.stepstone.de/upload_de/logo/A/logoATLAS-ELEKTRONIK-GmbH-6671DE.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/tkms-atlas-elektronik-gmbh-6671/work)
## [Signal Processing Engineer (m/w/d) - Artificial Intelligence](https://www.stepstone.de/jobs--Signal-Processing-Engineer-m-w-d-Artificial-Intelligence-Bremen-TKMS-ATLAS-ELEKTRONIK-GmbH--12914448-inline.html)
TKMS ATLAS ELEKTRONIK GmbH
Bremen
Partially remote
6 days ago
[![CompuGroup Medical Deutschland AG](https://www.stepstone.de/upload_de/logo/C/logoCompuGroup-Medical-SE-206929DE.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/compugroup-medical-deutschland-ag-206929/work)
## [AI Engineer (m/w/d)](https://www.stepstone.de/jobs--AI-Engineer-m-w-d-Koblenz-Berlin-CompuGroup-Medical-Deutschland-AG--12912881-inline.html)
CompuGroup Medical Deutschland AG
Koblenz, Berlin
Partially remote
6 days ago
[![Axontic GmbH](https://www.stepstone.de/jobs--KI-Entwickler-m-w-d-Oldenburg-CEWE-Stiftung-Co-KGaA--12933185-inline.html?rltr=24_24_25_seorl_m_0_0_0_0_0_0)](https://www.stepstone.de/cmp/en/axontic-gmbh-402209/work)
## [KI-Ingenieur - LangChain / Azure / Node.js (m/w/d)](https://www.stepstone.de/jobs--KI-Ingenieur-LangChain-Azure-Node-js-m-w-d-Bremen-Axontic-GmbH--12763005-inline.html)
Axontic GmbH
Bremen
Partially remote
1 week ago
[![primaholding GmbH](https://www.stepstone.de/upload_de/logo/P/logoprimaholding_GmbH_65149DE.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/primaholding-gmbh-65149/work)
## [KI-Entwickler - Informatiker, Wirtschaftsinformatiker o. ä. (m/w/d) - KI-Integration Geschäftsprozesse](https://www.stepstone.de/jobs--KI-Entwickler-Informatiker-Wirtschaftsinformatiker-o-ae-m-w-d-KI-Integration-Geschaeftsprozesse-Berlin-primaholding-GmbH--12897430-inline.html)
primaholding GmbH
Berlin
No cover letter required
1 week ago
[![Funk - Internationaler Versicherungsmakler und Risk Consultant](https://www.stepstone.de/upload_de/logo/2/logoFunk-Gruppe-Internationale-Versicherungsmakler-und-Risk-Consultants-4825DE.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/funk-internationaler-versicherungsmakler-und-risk-consultant-4825/work)
## [AI Automation Engineer – Generative KI (m/w/d)](https://www.stepstone.de/jobs--AI-Automation-Engineer-Generative-KI-m-w-d-Hamburg-Funk-Internationaler-Versicherungsmakler-und-Risk-Consultant--12755611-inline.html)
Funk - Internationaler Versicherungsmakler und Risk Consultant
Hamburg
Partially remote
No cover letter required
3 weeks ago
[![VRG GmbH](https://www.stepstone.de/upload_de/logo/C/logoVRG-GmbH-7370DE-2001171513.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/vrg-gmbh-7370/work)
## [Software-Engineer für soziale Innovation - Code with Purpose (m/w/d)](https://www.stepstone.de/jobs--Software-Engineer-fuer-soziale-Innovation-Code-with-Purpose-m-w-d-Oldenburg-Berlin-VRG-GmbH--12541970-inline.html)
VRG GmbH
Oldenburg, Berlin
Partially remote
3 weeks ago
#### Stepstone
[About us](https://www.stepstone.com/en/)[Press Release](https://www.stepstone.de/Ueber-StepStone/pressebereich)[Become a partner](https://www.stepstone.de/e-recruiting/en/cooperation-partner/become)
#### Jobseeker
[Career with Stepstone](https://www.stepstone.de/cmp/en/StepStone-GmbH-148733/work.html)[Salary Information](https://www.stepstone.de/gehalt.html)[Gross Net Calculator](https://www.stepstone.de/brutto-netto-rechner.html)[Career advice](https://www.stepstone.de/Karriere-Bewerbungstipps)[Create a CV](https://www.stepstone.de/cv-generator/)[Create a Cover Letter](https://www.stepstone.de/anschreiben-erstellen)[Terminate contracts here](https://www.stepstone.de/premium/subscription/cancel)
#### Recruiter
[Post Job Ads](https://www.stepstone.de/stellenanzeige-online-aufgeben)[Recruiting News](https://www.stepstone.de/e-recruiting/en/newsletterreg/hr-newsletter-en/)
#### Let's connect
[Give us feedback](https://email.stepstone.com/optiext/optiextension.dll?ID=w_1w22X272pIPVLyJM1z0Vly_OirHzFVujvTNjFn9MFYvKsMMlYlKiaZj3x9sWCYvVuyhFIcnUQjgF2RIQ)[](https://twitter.com/stepstone_de)[](https://www.facebook.com/stepstone.de)[](https://www.instagram.com/stepstone_de/)[](https://www.youtube.com/traumjob)
#### Apps
[](https://app.adjust.com/cyitte?fallback=http%3A%2F%2Fitunes.apple.com%2Fde%2Fapp%2Fstepstone-jobs%2Fid388123359%3Fmt=8)
[](https://app.adjust.com/kz0zwb)
[Privacy policy](https://www.stepstone.de/e-recruiting/en/legal/privacy-policy)
[Terms of Use](https://www.stepstone.de/ueber-stepstone/legal-notes/general-terms-use)
[Privacy settings](https://www.stepstone.de/ueber-stepstone/privacy-settings/)
[Contact us](https://www.stepstone.de/e-recruiting/en/contact)
[Terms and conditions](https://www.stepstone.de/e-recruiting/en/legal/tc-job-listings)
[Imprint](https://www.stepstone.de/e-recruiting/en/imprint)
* * *
#### The Stepstone Group GmbH © 2025
English
# Wir verwenden Cookies
Wir übermitteln personenbezogene Daten an Drittanbieter, die uns helfen, unser Webangebot zu verbessern. In diesem Zusammenhang werden auch Nutzungsprofile (u.a. auf Basis von Cookie-IDs) gebildet und angereichert, auch außerhalb des EWR.
Hierfür und um bestimmte Dienste zu nachfolgend aufgeführten Zwecken verwenden zu dürfen, benötigen wir Ihre Einwilligung. Indem Sie "Alle akzeptieren" klicken, stimmen Sie diesen (jederzeit widerruflich) zu. Dies umfasst auch Ihre Einwilligung in die Übermittlung bestimmter personenbezogener Daten in Drittländer, u.a. die USADie betreffenden Drittländer, insbesondere die USA, weisen im Zweifel nicht das Datenschutzniveau auf, das Sie unter der DSGVO genießen. Das kann Nachteile wie eine erschwerte Durchsetzung von Betroffenenrechten, eine fehlende Kontrolle der Weiterverarbeitung und Übermittlung der Daten oder Zugriffe auf die Daten durch staatliche Stellen, ins. Behörden der USA, zu Kontroll- und Überwachungszwecken bedeuten, ohne dass Ihnen Rechtsbehelfe dagegen zustehen.*, nach Art. 49 (1) (a) DSGVO. Unter "Einstellungen oder ablehnen" können Sie Ihre Einstellungen ändern oder die Datenverarbeitung ablehnen. Sie können Ihre Auswahl jederzeit unter [Privatsphäre](https://www.stepstone.de/ueber-stepstone/privatsphaere) am Seitenende ändern.
Informationen auf einem Gerät speichern und/oder abrufen
Für die Ihnen angezeigten Verarbeitungszwecke können Cookies, Geräte-Kennungen oder andere Informationen auf Ihrem Gerät gespeichert oder abgerufen werden.
Personalisierte Anzeigen und Inhalte, Anzeigen- und Inhaltsmessungen, Erkenntnisse über Zielgruppen und Produktentwicklungen
Anzeigen und Inhalte können basierend auf einem Profil personalisiert werden. Es können mehr Daten hinzugefügt werden, um Anzeigen und Inhalte besser zu personalisieren. Die Performance von Anzeigen und Inhalten kann gemessen werden. Erkenntnisse über Zielgruppen, die die Anzeigen und Inhalte betrachtet haben, können abgeleitet werden. Daten können verwendet werden, um Benutzerfreundlichkeit, Systeme und Software aufzubauen oder zu verbessern.
Fremdinhalte anzeigen (Soziale Netzwerke, Videos)
Inhalte von sozialen Netzwerken und eingebettete Inhalte von Drittanbietern können angezeigt werden.
Aus Authentifizierungen abgeleitete Kennungen
Wenn eine Kennung auf der Grundlage von Authentifizierungsdaten erstellt wird, wie z. B. Kontaktdaten im Zusammenhang mit Online-Konten, die Sie auf Websites oder Apps eingerichtet haben (z. B. E-Mail-Adresse, Telefonnummer) oder Kundenkennungen (z. B. eine von Ihrem Telekommunikationsanbieter bereitgestellte Kennung), dann kann diese Kennung dazu verwendet werden, Sie über Websites, Apps und Geräte hinweg wiederzuerkennen, wenn Sie mit denselben Kontaktdaten angemeldet sind.
Einstellungen oder ablehnen
Alles akzeptieren
Widerspruchsrechte zu Datenverarbeitungen auf Grundlage von berechtigten Interessen können Sie ebenfalls unter „Datenschutzerklärung“ ausüben.
[Datenschutzerklärung](https://www.stepstone.de/e-recruiting/rechtliches/datenschutzerklarung)[Impressum](https://www.stepstone.de/e-recruiting/impressum)[Cookie Richtlinie](https://www.stepstone.de/e-recruiting/rechtliches/cookie-policy/)


    "#
    }
}




test sample_job_posting_with_language_skills {
  functions [ExtractJobPosting]
  args {
    posting #"""
  [](https://www.stepstone.de/en)
Search
Sign in
Menu
Find Jobs
[![PwC logo](https://www.stepstone.de/upload_de/logo/7/logoPwC-2965DE-2509021401.gif)](https://www.stepstone.de/cmp/en/PwC-2965/work.html)
# AI Engineer (w/m/d)
  * PwC
  * Köln, Düsseldorf
  * Permanent contract
  * Full Time, Home office possible, Part time
  * Published: 2 days ago


No cover letter required
I'm interested
Save
[![PwC logo](https://www.stepstone.de/upload_de/logo/7/logoPwC-2965DE-2509021401.gif)](https://www.stepstone.de/cmp/en/PwC-2965/work.html)
**AI Engineer (w/m/d)**[ PwC](https://www.stepstone.de/cmp/en/PwC-2965/work.html)
I'm interested
Save
![loader](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20xmlns:xlink='http://www.w3.org/1999/xlink'%20width='852px'%20height='334px'%20viewBox='0%200%20852%20334'%3E%3Ctitle%3EHero-image-Desktop%3C/title%3E%3Cdefs%3E%3Cfilter%20id='filter-1'%3E%3CfeColorMatrix%20in='SourceGraphic'%20type='matrix'%20values='0%200%200%200%200.556863%200%200%200%200%200.592157%200%200%200%200%200.643137%200%200%200%201.000000%200'%3E%3C/feColorMatrix%3E%3C/filter%3E%3C/defs%3E%3Cg%20id='Page-1'%20stroke='none'%20stroke-width='1'%20fill='none'%20fill-rule='evenodd'%3E%3Cg%20id='CD-1769-D'%20transform='translate\(-150.000000,%20-539.000000\)'%3E%3Cg%20id='Hero-image-Desktop'%20transform='translate\(150.000000,%20539.000000\)'%3E%3Crect%20id='Mask'%20fill='%23F5F5F5'%20x='0'%20y='0'%20width='852'%20height='334'%3E%3C/rect%3E%3Cg%20id='_Common/icon/image/--48px'%20transform='translate\(414.000000,%20155.000000\)'%20filter='url\(%23filter-1\)'%3E%3Cg%3E%3Cpath%20d='M22.24,1.29674049e-13%20C23.2120212,1.29674049e-13%2024,0.78797884%2024,1.76%20L24,1.76%20L24,22.24%20C24,23.2120212%2023.2120212,24%2022.24,24%20L22.24,24%20L1.76,24%20C0.78797884,24%20-7.76267939e-13,23.2120212%20-7.76267939e-13,22.24%20L-7.76267939e-13,22.24%20L-7.76267939e-13,1.76%20C-7.76267939e-13,0.78797884%200.78797884,1.29674049e-13%201.76,1.29674049e-13%20L1.76,1.29674049e-13%20Z%20M22.755,19.445%20L20.5833595,19.4470352%20C20.5498111,19.4497574%2020.5163744,19.449709%2020.4833479,19.4470256%20L6.37389643,19.4457507%20C6.33516605,19.4497088%206.29596684,19.4500557%206.25683085,19.4466584%20L1.244,19.445%20L1.24444444,22.24%20C1.24444444,22.4930964%201.42682239,22.7035962%201.66732824,22.7472493%20L1.76,22.7555556%20L22.24,22.7555556%20C22.5247335,22.7555556%2022.7555556,22.5247335%2022.7555556,22.24%20L22.7555556,22.24%20L22.755,19.445%20Z%20M22.24,1.24444444%20L1.76,1.24444444%20C1.47526653,1.24444444%201.24444444,1.47526653%201.24444444,1.76%20L1.24444444,1.76%20L1.244,18.201%20L5.96,18.201%20L8.77887575,13.5051016%20C8.97727569,13.1741023%209.32374055,12.9597338%209.70849266,12.9299191%20C10.0451507,12.9038312%2010.3746131,13.0218714%2010.6171919,13.2503935%20L10.7156025,13.3549977%20L12.5127111,15.51232%20L15.9863575,10.302613%20C16.1842164,10.0051064%2016.5019182,9.81614769%2016.8483029,9.77816791%20L16.9793637,9.7710855%20L17.1120451,9.7786546%20C17.5114523,9.82383641%2017.8579057,10.0666924%2018.0388641,10.4206138%20L18.0928997,10.5425823%20L20.962,18.201%20L22.755,18.201%20L22.7555556,1.76%20C22.7555556,1.50690358%2022.5731776,1.29640381%2022.3326718,1.25275073%20L22.24,1.24444444%20Z%20M16.96384,11.07712%20L13.0866244,16.8962349%20C12.8751423,17.2134886%2012.4384041,17.2623159%2012.1619897,17.0221187%20L12.0908686,16.9494289%20L9.80679111,14.2091378%20L7.411,18.201%20L19.634,18.201%20L16.96384,11.07712%20Z%20M8.01777778,4.54769778%20C9.3039876,4.54769778%2010.3466667,5.59037685%2010.3466667,6.87658667%20C10.3466667,8.16279648%209.3039876,9.20547556%208.01777778,9.20547556%20C6.73156796,9.20547556%205.68888889,8.16279648%205.68888889,6.87658667%20C5.68888889,5.59037685%206.73156796,4.54769778%208.01777778,4.54769778%20Z%20M8.01777778,5.79214222%20C7.41885565,5.79214222%206.93333333,6.27766454%206.93333333,6.87658667%20C6.93333333,7.4755088%207.41885565,7.96103111%208.01777778,7.96103111%20C8.61669991,7.96103111%209.10222222,7.4755088%209.10222222,6.87658667%20C9.10222222,6.27766454%208.61669991,5.79214222%208.01777778,5.79214222%20Z'%20id='image'%20fill='%23566578'%3E%3C/path%3E%3C/g%3E%3C/g%3E%3C/g%3E%3C/g%3E%3C/g%3E%3C/svg%3E%0A)
![slide number 1](https://image-proxy.stepstone.com/live/image.png?url=https%3a%2f%2fvonqigb.s3.us-east-1.amazonaws.com%2fPWC%2fPWC%2bNEW%2b2025%2bSEP%2fPwC_Header_Sept2025.png&downsize=1140px%3A%2A&output-quality=85)
Bei PwC Deutschland arbeiten wir daran, entscheidende Herausforderungen zu lösen, nachhaltige Ergebnisse zu schaffen und das Vertrauen in die Wirtschaft und Gesellschaft auszubauen. Als Teil unseres Corporate Tax Teams behältst du bei nationalen und internationalen Steuerthemen den Durchblick für unsere Mandanten: Von der Buchführung und Steuererklärung über Restrukturierungen bis hin zu grenzüberschreitenden Transaktionen. Dafür sind deine Expertise und deine Ideen gefragt. Mit einem tollen Team an deiner Seite erlebst du eine erfrischende Mischung aus der Arbeit mit Zahlen und dem direkten Kontakt zu unseren Mandanten.
Für unseren Geschäftsbereich **[Tax& Legal Solutions](https://jobs.pwc.de/de/de/tax-solutions) **suchen wir dich **zum nächstmöglichen Zeitpunkt** als**AI Engineer (w/m/d).**
****Das erwartet dich****
**Aufbau** - Du kümmerst dich um den Aufbau intelligenter Automatisierungslösungen in der Steuerfunktion und arbeitest mit KI-Multiagentensystemen (z. B. mit LangChain, AutoGen, Copilot Studio, Agent OS, Aleph Alpha Pharia Stack etc.).
**Entwicklung** - Du entwickelst intelligente Komponenten zur Verarbeitung von Steuerdaten (OCR, NLP, Klassifizierung, Plausibilisierung).
**Integration** - Du integrierst bestehende ERP-Umgebungen und Steuersystemen (z. B. DATEV, SAP, Global Tax Center, DefTax).
**Gestaltung** - Du kreierst Datenschnittstellen & API-Kommunikation zwischen Mandanten- und Kanzleisystemen.
**Implementierung** - Du implementierst Prompt-Engineering-, Logging- und Monitoringstrukturen und arbeitest an Compliance-konformer KI-Architektur mit (GoBD, DSGVO, IDW PS 850/880).
****Das bringst du mit****
  * Du hast dein Studium in Informatik, Data Science, Mathematik oder einen vergleichbaren Studiengang abgeschlossen.
  * Du bringst Erfahrungen im Bereich Steuern und Finanzen mit.
  * Du bringst Kenntnisse im Umgang mit den folgenden Programmen mit: Python & Erfahrung mit Frameworks wie LangChain, AutoGen, HuggingFace, PyTorch.
  * Du verfügst zusätzlich über Kenntnisse in der Arbeit mit LLMs, Vektordatenbanken, Embedding-Modellen und weist Vertrautheit mit APIs (REST/gRPC), Docker & modernen Softwarearchitekturen auf.
  * Du verfügst über sehr gute Deutsch- und Englischkenntnisse in Wort und Schrift.
  * Du bringst Verantwortungsbewusstsein und Spaß an innovativen Lösungen mit, um so die Steuerfunktionen zu technologisieren.


****Deine Benefits****
**Flexibilität**
**Familie**
**Sicherheit** – Für deine (finanzielle) Sicherheit haben wir verschiedene Versicherungspakete zusammengestellt (z.B. Auslandskrankenversicherungen oder Unfallversicherungen) sowie eine betriebliche Altersvorsorge. Darüber hinaus gewähren wir dir im Krankheitsfall eine Beihilfe zur Lohnfortzahlung auch über die gesetzliche Frist von 6 Wochen hinaus.
**Gesundheit**
**Das ist noch nicht alles** – Wir möchten ein positives Arbeitsumfeld schaffen: Ein Umfeld, in dem flexibles und kreatives Arbeiten möglich ist, in dem Arbeit anerkannt und Leistung honoriert wird und auf das wir stolz sind. Alle Benefits findest du auf unserer Karriereseite.
****Kontakt****
Du hast Fragen zu dieser Position oder deiner Bewerbung?
Melde dich gerne bei **Ines Wallenwein** unter **+49 171 9473549**
* * *
I'm interested
* * *
Like this job?
close
* * *
[![Logo PwC](https://www.stepstone.de/upload_de/logo/7/logoPwC-2965DE-2509021401.gif)](https://www.stepstone.de/cmp/en/PwC-2965/work.html)
PwC
Unternehmensberatg., Wirtschaftsprüfg., Recht • 10,001+ Employees
[117 Jobs](https://www.stepstone.de/cmp/en/PwC-2965/work.html)Company Profile
* * *
#### Company Benefits
Medical Check-Up
Company Pension
Sports Activities
Flexible Working Hours
Company Laptop
Fitness Offers
Incentives and Events
Employee Discount
Sabbatical
Cafeteria
Company Mobile Phone
Coaching Offers
Home Office
Public Transport Ticket
Study Allowance
The employee benefits shown are company-specific and may vary depending on the position and department.
### In Short
  * **Industry** Unternehmensberatg., Wirtschaftsprüfg., Recht
  * **Founded**
  * **Location** Friedrich-Ebert-Anlage, Frankfurt
  * **Company size** 10,001+


### About us
**Grow here. Go further. ​**
Bist du bereit etwas zu verändern? Willst du mit deinen Stärken echten Mehrwert schaffen? In unserem weltweiten Netzwerk hast du unendlich viele Möglichkeiten, zu wachsen und dich weiterzuentwickeln. ​
Bei PwC Deutschland begleitest du unsere Kunden dabei entscheidende Herausforderungen von heute zu lösen und leistest damit einen Beitrag für unsere Wirtschaft und Gesellschaft. Wir sind Treiber der Transformation und Begleiter in das digitale Zeitalter. In unserem Team kommen die unterschiedlichsten Persönlichkeiten, mit herausragenden innovativen Ideen und einer Leidenschaft auf ihrem Fachgebiet zusammen, um gemeinsam die Zukunft in der Wirtschaftsprüfung Steuer- und Unternehmensberatung zu gestalten. ​
Bei uns trifft Expertenwissen, auf höchste Standards von Qualität und Fürsorge. Wir trauen uns Dinge kritisch zu hinterfragen, neue Wege zu gehen und somit jeden Tag aufs neue zu wachsen. ​
Als Arbeitgeber stellen wir deine Fähigkeiten und individuelle Entwicklung in den Mittelpunkt. Wir schaffen ein Arbeitsumfeld, in dem du dich mit deinem vollen Potenzial entfalten und dein Bestes geben kannst. So schaffen wir es für unsere Kunden einen echten Unterschied zu machen. Wir entdecken verborgene Talente und bauen langfristige Beziehungen auf, die von Vertrauen und Empathie geprägt sind. Wir arbeiten in interdisziplinären und inklusiven Teams zusammen und lernen so jeden Tag von den Besten. ​
**Gemeinsam gestalten wir die Zukunft von morgen. ​**
Wir schlagen ein neues Kapitel auf und bringen dich und damit auch PwC auf das nächste Level.
#### These jobs were popular with other job seekers
[![Bitburger Braugruppe GmbH](https://www.stepstone.de/upload_de/logo/1/logoBitburger-Braugruppe-GmbH-91766DE-2210111341.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/bitburger-braugruppe-gmbh-91766/work)
## [Data Engineer (m/w/d)](https://www.stepstone.de/jobs--Data-Engineer-m-w-d-Duesseldorf-Bitburger-Braugruppe-GmbH--12987367-inline.html)
Bitburger Braugruppe GmbH
Düsseldorf
2 days ago
[![FOM Hochschule für Oekonomie & Management gGmbH](https://www.stepstone.de/upload_de/logo/E/logoFOM-Hochschule-fur-Oekonomie-Management-gGmbH-91642DE-2205231624.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/fom-hochschule-fr-oekonomie-management-ggmbh-91642/work)
## [Data Engineer im KI Team (m/w/d)](https://www.stepstone.de/jobs--Data-Engineer-im-KI-Team-m-w-d-Essen-FOM-Hochschule-fuer-Oekonomie-Management-gGmbH--12978631-inline.html)
FOM Hochschule für Oekonomie & Management gGmbH
Essen
5 days ago
[![Peek & Cloppenburg B.V. & Co. KG](https://www.stepstone.de/upload_de/logo/1/logoPeek-Cloppenburg-KG-Dusseldorf-4968DE-2401101143.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/peek-cloppenburg-b-v-co-kg-4968/work)
## [Data &amp; AI Engineer (m/w/d)](https://www.stepstone.de/jobs--Data-AI-Engineer-m-w-d-Duesseldorf-Peek-Cloppenburg-B-V-Co-KG--12561895-inline.html)
Peek & Cloppenburg B.V. & Co. KG
Düsseldorf
Partially remote
1 week ago
[![Reply](https://www.stepstone.de/upload_de/logo/R/logoReply-AG-121954DE.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/reply-121954/work)
## [DevOps Engineer (m/w/d) || Data, AI, Machine Learning](https://www.stepstone.de/jobs--DevOps-Engineer-m-w-d-Data-AI-Machine-Learning-Berlin-Muenchen-Duesseldorf-Koeln-Leipzig-Reply--12800502-inline.html)
Reply
Berlin, München, Düsseldorf, Köln, Leipzig
Partially remote
5 days ago
[![CompuGroup Medical Deutschland AG](https://www.stepstone.de/upload_de/logo/C/logoCompuGroup-Medical-SE-206929DE.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/compugroup-medical-deutschland-ag-206929/work)
## [AI Engineer (m/w/d)](https://www.stepstone.de/jobs--AI-Engineer-m-w-d-Koblenz-Berlin-CompuGroup-Medical-Deutschland-AG--12912881-inline.html)
CompuGroup Medical Deutschland AG
Koblenz, Berlin
Partially remote
6 days ago
[![Verband Creditreform](https://www.stepstone.de/upload_de/logo/7/logoVereine-Creditreform-c-o-Verband-der-Vereine-Creditreform-e-V-320761DE-2301181732.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/verband-creditreform-320761/work)
## [Senior Data &amp; AI Cloud Platform Engineer (w/m/x)](https://www.stepstone.de/jobs--Senior-Data-AI-Cloud-Platform-Engineer-w-m-x-Neuss-Verband-Creditreform--12880758-inline.html)
Verband Creditreform
Neuss
Partially remote
14 hours ago
NEW
[![Birkenstock Group B.V. & Co. KG](https://www.stepstone.de/upload_de/logo/8/logoBirkenstock-Group-B-V-Co-KG-249716DE-2201110944.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/birkenstock-group-b-v-co-kg-249716/work)
## [Data Architect (m/f/d)](https://www.stepstone.de/jobs--Data-Architect-m-f-d-Koeln-Birkenstock-Group-B-V-Co-KG--12865339-inline.html)
Birkenstock Group B.V. & Co. KG
Köln
4 days ago
[![Vesterling AG](https://www.stepstone.de/upload_de/logo/C/logoVesterling-AG-6922DE-2201241418.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/vesterling-ag-6922/work)
## [Data Engineer Microsoft Fabric (mwd)](https://www.stepstone.de/jobs--Data-Engineer-Microsoft-Fabric-mwd-Duesseldorf-Vesterling-AG--12822522-inline.html)
Vesterling AG
Düsseldorf
Partially remote
1 week ago
[![REWE Group](https://www.stepstone.de/upload_de/logo/R/logoREWE-Group-4036DE.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/rewe-group-4036/work)
## [(Senior) Data Scientist Analytics (m/w/d)](https://www.stepstone.de/jobs--Senior-Data-Scientist-Analytics-m-w-d-Koeln-REWE-Group--10475189-inline.html)
REWE Group
Köln
Partially remote
No cover letter required
3 weeks ago
[![GBTEC Software AG](https://www.stepstone.de/upload_de/logo/0/logoGBTEC-Software-AG-62374DE-2411281003.gif?im=Resize=\(56,56\))](https://www.stepstone.de/cmp/en/gbtec-software-ag-62374/work)
## [Senior AI / Data Science Engineer (m/w/d)](https://www.stepstone.de/jobs--Senior-AI-Data-Science-Engineer-m-w-d-Bochum-GBTEC-Software-AG--12750861-inline.html)
GBTEC Software AG
Bochum
Partially remote
4 weeks ago
  * [AI Engineer Jobs](https://www.stepstone.de/jobs/ai-engineer)
  * [Softwareentwicklung Jobs](https://www.stepstone.de/jobs/softwareentwicklung)
  * [IT Jobs](https://www.stepstone.de/jobs/it)
  * [Junior Devops Engineer Jobs](https://www.stepstone.de/jobs/junior-devops-engineer)
  * [Computer Vision Engineer Jobs](https://www.stepstone.de/jobs/computer-vision-engineer)
  * [Software Development Engineer Jobs](https://www.stepstone.de/jobs/software-development-engineer)
  * [Engineering Jobs](https://www.stepstone.de/jobs/engineering)
  * [Berechnungsingenieur/In Jobs](https://www.stepstone.de/jobs/berechnungsingenieur-in?q=berechnungsingenieur%2fin)
  * [Softwareingenieur Jobs](https://www.stepstone.de/jobs/softwareingenieur)
  * [SCADA Engineer Jobs](https://www.stepstone.de/jobs/scada-engineer)
  * [Junior Engineer Jobs](https://www.stepstone.de/jobs/junior-engineer)
  * [Software Engineer Jobs](https://www.stepstone.de/jobs/software-engineer)
  * [Devops Engineer Jobs](https://www.stepstone.de/jobs/devops-engineer)
  * [Engineer Jobs](https://www.stepstone.de/jobs/engineer)
  * [Senior Software Engineer Jobs](https://www.stepstone.de/jobs/senior-software-engineer)
  * [SW Engineer Jobs](https://www.stepstone.de/jobs/sw-engineer)
  * [IT Software Engineering Jobs](https://www.stepstone.de/jobs/it-software-engineering)
  * [Software-Engineering Jobs](https://www.stepstone.de/jobs/software-engineering)
  * [Berechnungsingenieur Jobs](https://www.stepstone.de/jobs/berechnungsingenieur)


#### Stepstone
[About us](https://www.stepstone.com/en/)[Press Release](https://www.stepstone.de/Ueber-StepStone/pressebereich)[Become a partner](https://www.stepstone.de/e-recruiting/en/cooperation-partner/become)
#### Jobseeker
[Career with Stepstone](https://www.stepstone.de/cmp/en/StepStone-GmbH-148733/work.html)[Salary Information](https://www.stepstone.de/gehalt.html)[Gross Net Calculator](https://www.stepstone.de/brutto-netto-rechner.html)[Career advice](https://www.stepstone.de/Karriere-Bewerbungstipps)[Create a CV](https://www.stepstone.de/cv-generator/)[Create a Cover Letter](https://www.stepstone.de/anschreiben-erstellen)[Terminate contracts here](https://www.stepstone.de/premium/subscription/cancel)
#### Recruiter
[Post Job Ads](https://www.stepstone.de/stellenanzeige-online-aufgeben)[Recruiting News](https://www.stepstone.de/e-recruiting/en/newsletterreg/hr-newsletter-en/)
#### Let's connect
[Give us feedback](https://email.stepstone.com/optiext/optiextension.dll?ID=w_1w22X272pIPVLyJM1z0Vly_OirHzFVujvTNjFn9MFYvKsMMlYlKiaZj3x9sWCYvVuyhFIcnUQjgF2RIQ)[](https://twitter.com/stepstone_de)[](https://www.facebook.com/stepstone.de)[](https://www.instagram.com/stepstone_de/)[](https://www.youtube.com/traumjob)
#### Apps
[](https://app.adjust.com/cyitte?fallback=http%3A%2F%2Fitunes.apple.com%2Fde%2Fapp%2Fstepstone-jobs%2Fid388123359%3Fmt=8)
[](https://app.adjust.com/kz0zwb)
[Privacy policy](https://www.stepstone.de/e-recruiting/en/legal/privacy-policy)
[Terms of Use](https://www.stepstone.de/ueber-stepstone/legal-notes/general-terms-use)
[Privacy settings](https://www.stepstone.de/ueber-stepstone/privacy-settings/)
[Contact us](https://www.stepstone.de/e-recruiting/en/contact)
[Terms and conditions](https://www.stepstone.de/e-recruiting/en/legal/tc-job-listings)
[Imprint](https://www.stepstone.de/e-recruiting/en/imprint)
* * *
#### The Stepstone Group GmbH © 2025
English
Deutsch
Deutsch
English
Wir übermitteln personenbezogene Daten an Drittanbieter, die uns helfen, unser Webangebot zu verbessern. In diesem Zusammenhang werden auch Nutzungsprofile (u.a. auf Basis von Cookie-IDs) gebildet und angereichert, auch außerhalb des EWR.
Hierfür und um bestimmte Dienste zu nachfolgend aufgeführten Zwecken verwenden zu dürfen, benötigen wir Ihre Einwilligung. Indem Sie "Alle akzeptieren" klicken, stimmen Sie diesen (jederzeit widerruflich) zu. Dies umfasst auch Ihre Einwilligung in die Übermittlung bestimmter personenbezogener Daten in Drittländer, u.a. die USADie betreffenden Drittländer, insbesondere die USA, weisen im Zweifel nicht das Datenschutzniveau auf, das Sie unter der DSGVO genießen. Das kann Nachteile wie eine erschwerte Durchsetzung von Betroffenenrechten, eine fehlende Kontrolle der Weiterverarbeitung und Übermittlung der Daten oder Zugriffe auf die Daten durch staatliche Stellen, ins. Behörden der USA, zu Kontroll- und Überwachungszwecken bedeuten, ohne dass Ihnen Rechtsbehelfe dagegen zustehen.*, nach Art. 49 (1) (a) DSGVO. Unter "Einstellungen oder ablehnen" können Sie Ihre Einstellungen ändern oder die Datenverarbeitung ablehnen. Sie können Ihre Auswahl jederzeit unter [Privatsphäre](https://www.stepstone.de/ueber-stepstone/privatsphaere) am Seitenende ändern.
Alles akzeptieren
Einstellungen oder ablehnen
Widerspruchsrechte zu Datenverarbeitungen auf Grundlage von berechtigten Interessen können Sie ebenfalls unter „Datenschutzerklärung“ ausüben.
[Datenschutzerklärung](https://www.stepstone.de/e-recruiting/rechtliches/datenschutzerklarung)[Impressum](https://www.stepstone.de/e-recruiting/impressum)[Cookie Richtlinie](https://www.stepstone.de/e-recruiting/rechtliches/cookie-policy/)




    "#
    }
}
