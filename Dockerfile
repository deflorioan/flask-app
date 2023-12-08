FROM python:3.11.7-alpine3.17
WORKDIR /usr/scr/app

COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

EXPOSE 5000
CMD ["python","app.py"]
