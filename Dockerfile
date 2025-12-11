# Évite les versions flottantes, utilise une version exacte
FROM python:3.7.17-slim AS base

# Crée un répertoire applicatif
WORKDIR /app

# Installe les dépendances système (avec versions figées)
RUN apt-get update \
 && apt-get install -y --no-install-recommends gcc=4:10.2.1-1 libpq-dev=13.13-0+deb11u1 \
 && rm -rf /var/lib/apt/lists/*



# Copie les fichiers dans l'image
COPY requirements.txt .

# Installe les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Copie le reste de l'application
COPY . .

# Expose le port d'exécution
EXPOSE 4000

# Définit l'utilisateur non-root (sécurité)
RUN useradd -m appuser
USER appuser

# Commande de lancement
CMD ["python", "main.py"]
