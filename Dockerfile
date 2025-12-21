# Utiliser une version stable de Python
FROM python:3.11-slim

# Empêcher Python de générer des fichiers .pyc
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Créer le dossier de travail
WORKDIR /app

# Installer les dépendances système pour PostgreSQL
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

# Installer les dépendances Python
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copier tout le projet dans le conteneur
COPY . /app/

# Collecter les fichiers statiques
RUN python manage.py collectstatic --noinput

# Lancer l'application avec Gunicorn (Vérifiez bien que le nom est 'propri')
CMD ["gunicorn", "propri.wsgi:application", "--bind", "0.0.0.0:8000"]
