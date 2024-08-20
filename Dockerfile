# Builder Image
FROM python:3.9.7-slim-bullseye as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app
USER root
# Ensure the /app directory has the correct permissions
RUN mkdir -p /app

RUN python -m venv /app/venv
COPY requirements.txt .
# Use the newest pip version to have fewer CVEs
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM python:3.9.7-slim-bullseye

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
RUN chmod +x /app/main.py
RUN chmod 777 /app/main.py
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
