FROM node:12.16-alpine
LABEL version="2.0"
LABEL description="Containt NodeJs, Ruby, Python and Java"
LABEL maintainer="https://github.com/blacksam07"

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}" 

RUN apk update \
	&& apk add --update python2 python3 \
	&& apk add --update ruby ruby-bundler \
	&& apk fetch openjdk8 \
	&& apk add openjdk8-jre \
	&& python --version \
	&& ruby -v \
	&& java -version \
	&& rm -rf /var/cache/apk/*
