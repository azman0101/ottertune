FROM tensorflow/tensorflow

ENV PASSWORD=root
ENV DBHOST=localhost
ENV DBNAME=ottertune
ENV DBUSER=dbuser
ENV DBPASSWD=test123
ENV REPOPATH=/ottertune
ENV SETTINGSPATH=${REPOPATH}/server/website/website/settings

RUN apt-get -qq update && \
    apt-get install git python-pip python-dev python-mysqldb libssl-dev libmysqlclient-dev libffi-dev python-tk -yqq && rm -rf /var/lib/apt/lists/*
    apt-get install python-pip python-dev python-mysqldb rabbitmq-server gradle default-jdk libmysqlclient-dev  >> $LOG 2>&1

RUN mkdir ${REPOPATH}
COPY . ${REPOPATH}/
WORKDIR /${REPOPATH}/server/website/
RUN pip2 install -U pip && ls -lah && pwd && pip2 install -U -r requirements.txt

RUN cd /server/website/website/settings/ && cp credentials_TEMPLATE.py credentials.py && sed -i "s/ADD ME!!/${PASSWORD}/g" credentials.py && sed -i "s/'HOST': '',/'HOST': 'db',/g" credentials.py && sed -i "s#BROKER_URL = 'amqp://guest:guest@localhost:5672//'#BROKER_URL = 'amqp://guest:guest@rabbitmq:5672//'#g" common.py && cat credentials.py && cat common.py

#CMD ["pip2", "freeze"]

#CMD ["mysqladmin", "create", "-uroot", "-proot", "ottertune"]

#CMD ["/usr/bin/python2", "manage.py", "makemigrations", "website"]
#CMD ["/usr/bin/python2", "manage.py", "migrate"]
