ARG PYTHON="3.8"
ARG ALPINE_VERSION="3.11"
FROM python:${PYTHON}-alpine${ALPINE_VERSION} as builder

COPY . /application

RUN apk add --no-cache --virtual build-dependencies git bluez-dev musl-dev make gcc glib-dev musl-dev && \
    cd /application && \
    pip install -r requirements.txt && \
    touch config.yaml && \
    pip install `./gateway.py -r all`

FROM python:${PYTHON}-alpine${ALPINE_VERSION}
ARG PYTHON

RUN apk add --no-cache tzdata bluez bluez-libs bluez-deprecated

COPY --from=builder /usr/local/lib/python${PYTHON}/site-packages /usr/local/lib/python${PYTHON}/site-packages

COPY . /application
WORKDIR /application

ENTRYPOINT ["python3", "/application/gateway.py"]
