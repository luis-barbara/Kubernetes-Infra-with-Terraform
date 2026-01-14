FROM python:3.12-slim

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN pip install poetry

WORKDIR /app

COPY poetry.lock pyproject.toml /app/

COPY . .

RUN poetry install -n 

EXPOSE 8000

RUN poetry run python manage.py collectstatic --noinput

CMD ["poetry", "run", "uvicorn", "dali.asgi:application", "--host", "0.0.0.0", "--port", "8000"]

