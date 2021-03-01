ARG DOCKER_VERSION=19.03
ARG PYTHON_VERSION=3.7.10

ARG BUILD_DEBIAN_VERSION=slim-stretch

FROM python:${PYTHON_VERSION}-${BUILD_DEBIAN_VERSION} as build
RUN apt update && apt install --no-install-recommands -y \
		curl \
		gcc \
		libc-dev \
		libffi-dev \
		libgcc-dev \
		libssl-dev \
		make \
		openssl \
		zlib1g-dev
ENTRYPOINT [ "sh", "/usr/local/bin/docker-compose-entrypoint.sh" ]
WORKDIR /code/

COPY docker-compose-entrypoint.sh /usr/local/bin/
RUN pip install \
			virtualenv==20.4.0 \
			tox==3.21.2

COPY requirements-dev.txt  .
COPY requirements-indirect.txt .
COPY requirements.txt .
RUN pip install \
			-r requirements.txt \
			-r requirements-indirect.txt \
			-r requirements-dev.txt

COPY .pre-commit-config.yaml .
COPY tox.ini .
COPY setup.py .
COPY README.md .
COPY compose compose/
RUN tox -e py37 --notest

COPY . .
ARG GIT_COMMIT=unkonwn
ENV DOCKER_COMPOSE_GITSHA=$GIT_COMMIT
RUN script/build/linux-entrypoint
