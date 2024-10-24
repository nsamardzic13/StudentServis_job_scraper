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

COPY main.py ./
COPY helper.py ./
COPY config.json ./

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION

ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_REGION=${AWS_REGION}

ENTRYPOINT [".venv/bin/python", "main.py"]