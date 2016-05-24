FROM jenkinsci/jenkins:latest

USER root

RUN apt-get clean && apt-get update && apt-get -y upgrade

RUN wget -qO- https://bootstrap.pypa.io/get-pip.py | python
RUN pip install awscli

RUN wget -qO- https://get.docker.com | sh
RUN usermod -aG docker jenkins

USER jenkins

COPY plugins.txt /usr/share/jenkins/plugins.txt

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
