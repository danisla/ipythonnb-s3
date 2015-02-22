FROM python:2.7
MAINTAINER disla@jpl.nasa.gov

ADD requirements.txt /tmp/

RUN pip install -r /tmp/requirements.txt

ADD s3nbmanager.py /tmp/
ADD setup.py /tmp/

WORKDIR /tmp

RUN \
  python /tmp/setup.py install

WORKDIR /opt/app/

ADD start.sh /opt/app/

RUN \
  chmod 0755 /opt/app/start.sh

CMD ["/opt/app/start.sh"]
