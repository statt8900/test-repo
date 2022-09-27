ARG PYTHON_VERSION="3.8.13"

FROM python:${PYTHON_VERSION}-slim as builder

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1

ARG RUNTIME_APT_DEPS="postgresql-client \
    libpq-dev"

ENV RUNTIME_APT_DEPS=${RUNTIME_APT_DEPS} \
    POETRY_VERSION==1.2.0

ARG ADDITIONAL_RUNTIME_APT_DEPS=""
ENV ADDITIONAL_RUNTIME_APT_DEPS=${ADDITIONAL_RUNTIME_APT_DEPS}

ARG RUNTIME_APT_COMMAND="echo"
ENV RUNTIME_APT_COMMAND=${RUNTIME_APT_COMMAND}

ARG ADDITIONAL_RUNTIME_APT_COMMAND=""
ENV ADDITIONAL_RUNTIME_APT_COMMAND=${ADDITIONAL_RUNTIME_APT_COMMAND}

ARG ADDITIONAL_RUNTIME_APT_ENV=""

RUN mkdir -pv /usr/share/man/man1 \
    && mkdir -pv /usr/share/man/man7 \
    && export ${ADDITIONAL_RUNTIME_APT_ENV?} \
    && bash -o pipefail -e -u -x -c "${RUNTIME_APT_COMMAND}" \
    && bash -o pipefail -e -u -x -c "${ADDITIONAL_RUNTIME_APT_COMMAND}" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    ${RUNTIME_APT_DEPS} \
    ${ADDITIONAL_RUNTIME_APT_DEPS} \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


ENV APP_HOME=/home/app
WORKDIR ${APP_HOME}

# Install poetry
RUN pip install "poetry==$POETRY_VERSION"
# Add the lock file
COPY poetry.lock pyproject.toml  ${APP_HOME}/

# Project initialization:
# Need to touch these files or poetry complains!
# TODO: fix how sklearn is installed. pip can install it but poetry cannot
RUN mkdir -p ${APP_HOME}/src/app && touch ${APP_HOME}/src/app/__init__.py && touch ${APP_HOME}/README.md
RUN poetry config virtualenvs.in-project true \
    && poetry install --only main --only dev
ENV PYTHONPATH=${APP_HOME}/src:${PYTHONPATH}

FROM python:${PYTHON_VERSION}-slim as final

ENV APP_HOME=/home/app
WORKDIR $APP_HOME
# Move the virtual from building image to final image
COPY --from=builder ${APP_HOME}/.venv ${APP_HOME}/.venv
# Set up the path variables
ENV PATH="${APP_HOME}/.venv/bin:$PATH"
ENV PYTHONPATH=${APP_HOME}/src:${PYTHONPATH}

# Install runtime apt dependencies
ARG RUNTIME_APT_DEPS="\
    postgresql-client \
    libpq-dev \
    sudo"
RUN apt-get update -y --no-install-recommends \
    && apt-get install -y --no-install-recommends $RUNTIME_APT_DEPS \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./src ./src
