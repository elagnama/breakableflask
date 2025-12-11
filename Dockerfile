FROM python:3.12.12-alpine3.23 AS builder

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Installer build deps et dépendances Python
RUN apk add --no-cache build-base postgresql-dev

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt \
    && pip freeze > requirements-pinné.txt

# Étape finale
FROM python:3.12.12-alpine3.23 AS final

WORKDIR /app

# Ajoute un utilisateur non root
RUN adduser --disabled-password --gecos "" ela

# Installer les dépendances runtime
RUN apk add --no-cache postgresql-libs

# Copier uniquement ce qui est nécessaire
COPY --from=builder /usr/lib/python3.12/site-packages /usr/lib/python3.12/site-packages
COPY --from=builder /usr/bin/python3 /usr/bin/python3
COPY --from=builder /usr/bin/pip3 /usr/bin/pip3

COPY . .

USER ela

EXPOSE 4000

CMD ["python", "main.py"]
