FROM python:3.13-alpine
LABEL maintainer='heropixel.co.za'

#Env values
ENV PYTHONUNBUFFERED=1

#Setup workspace
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app

RUN apk update

#Ports
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev libpq-dev python3-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt;  \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps


ARG USERNAME=django-app
RUN adduser \
    --disabled-password \
    --gecos "" \
    --shell "/sbin/nologin" \
    $USERNAME
USER $USERNAME

ENV PATH="/py/bin:$PATH"