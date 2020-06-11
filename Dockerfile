ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-transport-https \
    curl \
    octave \
    octave-doc \
    && apt-get purge -y && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

ARG GID
ARG GID_NAME
ARG UID
ARG UID_NAME

RUN addgroup --gid ${GID} ${GID_NAME} \
    && adduser --uid ${UID} --ingroup ${GID_NAME} --home /home/${UID_NAME} --shell /bin/bash --disabled-password --gecos "" ${UID_NAME}

COPY --chown=${UID_NAME}:${GID_NAME} data /home/${UID_NAME}/

RUN apt-get update \
    && pip install --upgrade --requirement /home/${UID_NAME}/requirements.txt \
    && apt-get purge -y && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/${UID_NAME}/data

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["octave-cli", "--path", "./"]
