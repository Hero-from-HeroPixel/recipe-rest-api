FROM python:3.13-slim
LABEL maintainer='heropixel.co.za'

#Env values
ENV PYTHONUNBUFFERED=1

#Setup environment
RUN apt update && apt install git -y

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
    if [ "$DEV" = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt;  \
    fi && \
    rm -rf /tmp

ARG USERNAME=django-app
RUN adduser \
    --disabled-password \
    --gecos "" \
    --shell "/sbin/nologin" \
    $USERNAME
USER $USERNAME

ENV PATH="/py/bin:$PATH"