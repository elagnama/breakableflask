FROM python:3.12.12-alpine3.23 AS final

WORKDIR /app

# Ajoute un utilisateur non root
RUN adduser --disabled-password --gecos "" ela

# Installer les dépendances runtime (avec version fixée)
RUN apk add --no-cache postgresql-libs=15.3-r0

# Copier les dépendances Python et les binaires essentiels
COPY --from=builder /usr/lib/python3.12/site-packages /usr/lib/python3.12/site-packages
COPY --from=builder /usr/bin/python3 /usr/bin/python3
COPY --from=builder /usr/bin/pip3 /usr/bin/pip3

# Copier le code
COPY . .

USER ela

EXPOSE 4000

CMD ["python", "main.py"]
