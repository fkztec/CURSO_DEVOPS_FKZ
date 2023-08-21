FROM python:3

RUN apt-get update -y && \
  apt-get install -y build-essential python3-pip libffi-dev python3-dev python3-setuptools libssl-dev

WORKDIR /app

RUN pip install Flask requests flask_mysqldb

COPY . .

EXPOSE 5000

CMD ["python", "./app.py"]