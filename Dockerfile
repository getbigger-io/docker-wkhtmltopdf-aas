FROM python:bookworm

RUN apt-get update
RUN apt-get upgrade -y

# Download and install wkhtmltopdf
RUN apt-get install -y build-essential xorg libssl-dev libxrender-dev wget gdebi
RUN wget http://ftp.de.debian.org/debian/pool/main/w/wkhtmltopdf/wkhtmltopdf_0.12.6-2+b1_amd64.deb
RUN gdebi --n wkhtmltopdf_0.12.6-2+b1_amd64.deb

# Install dependencies for running web service
RUN apt-get install -y python3-pip
RUN pip install werkzeug gunicorn

ADD app.py /app.py
EXPOSE 80

ENTRYPOINT ["usr/local/bin/gunicorn"]

# Show the extended help
CMD ["-b", "0.0.0.0:80", "--log-file", "-", "app:application"]
