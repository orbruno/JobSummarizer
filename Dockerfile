FROM python:3.11-slim

WORKDIR /

# Copy dependency files
COPY requirements.txt ./

RUN apt-get update && apt-get install -y --no-install-recommends build-essential

RUN pip install --no-cache-dir -r requirements.txt

RUN crawl4ai-setup

# Copy application code
COPY app/ ./app/

ENV PYTHONPATH=/app


EXPOSE 8000


CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
