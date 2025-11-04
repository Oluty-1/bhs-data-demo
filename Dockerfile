FROM python:3.11-slim

WORKDIR /app

RUN pip install --no-cache-dir flask pymysql cryptography

COPY app.py .
COPY templates templates/

CMD ["python", "app.py"]