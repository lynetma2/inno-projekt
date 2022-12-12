FROM python:3.10
WORKDIR /scraper
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
ENV POSTGRES_PASSWORD=bitconnect
COPY ./maling .
CMD ["./insertScript.sh"]
