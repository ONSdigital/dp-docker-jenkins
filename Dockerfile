FROM jenkins/jenkins:latest

USER root

RUN wget -qO- https://deb.nodesource.com/setup_8.x | bash

RUN echo deb https://dl.bintray.com/sbt/debian / > /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

RUN echo deb http://dl.google.com/linux/chrome/deb/ stable main > /etc/apt/sources.list.d/google-chrome.list
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

RUN apt-get clean && apt-get update && apt-get -y upgrade

RUN apt-get -y install   \
    bzip2                \
    google-chrome-stable \
    make                 \
    nodejs               \
    sbt                  \
    xvfb

RUN wget -qO- https://bootstrap.pypa.io/get-pip.py | python
RUN pip install awscli

RUN wget -qO- https://storage.googleapis.com/golang/go1.10.2.linux-amd64.tar.gz | tar -xvz -C /usr/local
ENV PATH $PATH:/usr/local/go/bin

RUN git clone https://github.com/awslabs/amazon-ecr-credential-helper \
    gopath/src/github.com/awslabs/amazon-ecr-credential-helper    &&  \
    cd gopath/src/github.com/awslabs/amazon-ecr-credential-helper &&  \
    GOPATH=/gopath make build >/dev/null                          &&  \
    cp bin/local/docker-credential-ecr-login /usr/local/bin

RUN wget -qO- https://get.docker.com | sh
RUN usermod -aG docker jenkins

USER jenkins

RUN /usr/local/bin/install-plugins.sh \
    build-monitor-plugin              \
    cucumber-reports                  \
    docker-workflow                   \
    github                            \
    workflow-aggregator               \
    xvfb
