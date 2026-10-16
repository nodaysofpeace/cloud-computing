FROM python:3.14-alpine
# Image waar python in staat.
WORKDIR /app
# Gebruik /app als werkmap
COPY requirements.txt .
# Copy mijn requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
# Run de volgende commanddos tijdens het bouwen v/d container
COPY . .
# Copy de overige dingen
CMD ["python", "app.py"]
# Geef welke programmas de container bij het starten uitvoert.