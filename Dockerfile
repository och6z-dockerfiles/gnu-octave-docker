ARG CODE_VERSION

FROM debian:${CODE_VERSION}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
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

WORKDIR /home/${UID_NAME}/_data
