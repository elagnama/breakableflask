FROM python:3.12.12-alpine3.23 AS builder

RUN apk update \
    && apk add --no-cache \
        build-base \
        postgresql-dev \
    && rm -rf /var/cache/apk/*

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
RUN pip freeze > requirements-pinné.txt
FROM python:3.12.12-alpine3.23 AS final
COPY . .

RUN apk update \
    && apk add --no-cache \
        postgresql-libs \
    && rm -rf /var/cache/apk/*

WORKDIR /app

RUN adduser --disabled-password --gecos "" ela
USER ela


COPY --from=builder /usr/lib/python3.12/site-packages /usr/lib/python3.12/site-packages
COPY --from=builder /usr/bin /usr/bin


COPY . /app

EXPOSE 4000

CMD ["python", "main.py"]
