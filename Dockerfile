ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    octave \
    octave-doc \
    liboctave-dev \
    make \
    && apt-get purge -y && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

ARG GID
ARG GID_NAME
ARG UID
ARG UID_NAME

RUN addgroup --gid ${GID} ${GID_NAME} \
    && adduser --uid ${UID} \
    --ingroup ${GID_NAME} \
    --home /home/${UID_NAME} \
    --shell /bin/bash \
    --disabled-password \
    --gecos "" ${UID_NAME}

COPY --chown=${UID_NAME}:${GID_NAME} data /home/${UID_NAME}/

RUN apt-get update \
    && pip install --upgrade --requirement /home/${UID_NAME}/requirements.txt \
    && apt-get purge -y && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

ENV MESA_LOADER_DRIVER_OVERRIDE i965

USER ${UID_NAME}

WORKDIR /home/${UID_NAME}/data

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["octave-cli", "--path", "./"]
#CMD ["octave", "--force-gui", "--path", "./"]

#docker builder build --no-cache --build-arg PYTHON_VERSION=slim --build-arg GID=$(id -g) --build-arg GID_NAME=$(id -gn) --build-arg UID=$(id -u) --build-arg UID_NAME=$(id -un) --file Dockerfile --tag image-name:version .
#xhost +local:docker
#docker container run --interactive --tty --volume /tmp/.X11-unix:/tmp/.X11-unix --env DISPLAY=unix$DISPLAY --name container-name image-name:version
