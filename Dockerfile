FROM jenkinsci/jenkins:latest

USER root

RUN wget -qO- https://deb.nodesource.com/setup_4.x | bash

RUN apt-get clean && apt-get update && apt-get -y upgrade
RUN apt-get -y install nodejs bzip2

RUN wget -qO- https://bootstrap.pypa.io/get-pip.py | python
RUN pip install awscli

RUN wget -qO- https://storage.googleapis.com/golang/go1.7.1.linux-amd64.tar.gz | tar -xvz -C /usr/local
ENV PATH $PATH:/usr/local/go/bin

RUN wget -qO- https://get.docker.com | sh
RUN usermod -aG docker jenkins

USER jenkins

COPY plugins.txt /usr/share/jenkins/plugins.txt

RUN /usr/local/bin/install-plugins.sh $(tr '\n' ' ' < /usr/share/jenkins/plugins.txt)
