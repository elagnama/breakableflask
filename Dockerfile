# Étape 1 : Builder
FROM python:3.12.12-alpine3.23 AS builder

WORKDIR /app

RUN apk add --no-cache build-base postgresql-dev

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Étape 2 : Image finale
FROM python:3.12.12-alpine3.23 AS final

WORKDIR /app

RUN adduser --disabled-password --gecos "" ela && \
    apk add --no-cache postgresql-libs=15.3-r0

COPY --from=builder /usr/lib/python3.12/site-packages /usr/lib/python3.12/site-packages
COPY --from=builder /usr/bin/python3 /usr/bin/python3
COPY --from=builder /usr/bin/pip3 /usr/bin/pip3

COPY . .

USER ela

EXPOSE 4000

CMD ["python", "main.py"]
