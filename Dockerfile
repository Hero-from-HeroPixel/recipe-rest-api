FROM python:3.13-alpine
LABEL maintainer='heropixel.co.za'

#Env values
ENV PYTHONUNBUFFERED=1

#Setup workspace
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app

#Ports
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV == "true"]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt;  \
    else \
        echo "Dev is false"; \
    fi && \
    rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

ENV PATH="/py/bin:$PATH"

USER django-user
