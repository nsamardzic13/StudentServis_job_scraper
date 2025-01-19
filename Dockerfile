FROM python:3.11-bullseye AS builder

RUN apt update && \
    apt upgrade  -y

RUN pip install poetry==1.7.0

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

COPY poetry.lock pyproject.toml ./
RUN poetry install --no-root && rm -rf $POETRY_CACHE_DIR

FROM python:3.11-bullseye AS runner

ENV VIRTUAL_ENV=.venv 

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}

# Set the working directory
COPY main.py ./
COPY helper.py ./
COPY config.json ./

# Define the SMTP_USER and SMTP_PASSWORD as build arguments
ARG SMTP_USER
ARG SMTP_PASSWORD

ENV SMTP_USER=${SMTP_USER}
ENV SMTP_PASSWORD=${SMTP_PASSWORD}

# Print SMTP_USER during the build process
RUN echo "SMTP_USER is: $SMTP_USER"

ENTRYPOINT [".venv/bin/python", "main.py"]