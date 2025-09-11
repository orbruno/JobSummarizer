# JobSummariser

A FastAPI-based microservice for extracting and summarizing job postings from web pages using BAML and Crawl4AI.

## Features

- **Job Posting Extraction**: Fetches job posting HTML from a given URL and extracts structured information using BAML.
- **Async Web Crawling**: Utilizes Crawl4AI for robust, asynchronous crawling and HTML extraction.
- **Schema-Driven Output**: Returns a rich JSON object with nested fields (contract details, language skills, competencies, etc.) as defined in the BAML schema.
- **API-First Design**: Easily testable via Postman or any HTTP client.

## Tech Stack

- **FastAPI**: High-performance Python web framework for building APIs.
- **BAML**: BoundaryML's schema and extraction language for job postings.
- **Crawl4AI**: Asynchronous web crawler for reliable HTML extraction.
- **Pydantic**: Data validation and serialization.
- **nest_asyncio**: Enables async event loop nesting (required for FastAPI + Crawl4AI).

## API Endpoints

### `POST /generate-job-json`

Extracts job posting details from a given URL.

**Request Body:**

```json
{
  "url": "https://example.com/job-posting"
}
```

**Response:**
Returns a JSON object with all fields defined in the BAML `JobPosting` schema, e.g.:

```json
{
  "title": "AI Engineer",
  "company": "PwC",
  "contractDetails": { ... },
  "languageSkills": { ... },
  "competenciesAndSkills": { ... },
  ...
}
```

## Project Structure

```
JobSummariser/
├── main.py                # FastAPI app and endpoints
├── baml_src/
│   └── jobposting.baml    # BAML schema and extraction logic
├── crawl4ai_test.ipynb    # Notebook for crawling and extraction tests
├── .gitignore             # Excludes notebooks, env files, cache, etc.
├── README.md              # Project documentation
└── ...
```

## Setup & Installation

1. **Clone the repository**
   ```zsh
   git clone <repo-url>
   cd JobSummariser
   ```
2. **Initialize environment (using uv)**
   ```zsh
   uv venv
   source .venv/bin/activate
   uv pip install -r requirements.txt
   ```
3. **Run the API**
   ```zsh
   uvicorn main:app --reload
   ```

## Testing

- Use [Postman](https://www.postman.com/) or `curl` to test the `/generate-job-json` endpoint.
- See `crawl4ai_test.ipynb` for notebook-based crawling and extraction tests.

## Development Notes

- Ensure all dependencies are installed in the correct Python environment (see `.venv`).
- The BAML schema (`jobposting.baml`) defines the output structure and extraction logic. Update as needed for new fields.
- `.gitignore` excludes notebooks, environment files, and other non-essential files from version control.

## License

MIT

## Author

Orlando Bruno
