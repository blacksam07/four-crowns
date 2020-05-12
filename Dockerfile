FROM node:12.16-alpine
LABEL version="2.0"
LABEL description="Containt NodeJs, Ruby, Python and Java"
LABEL maintainer="https://github.com/blacksam07"

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"
ENV BUNDLER_VERSIONS="bundler:1.17.0 bundler:1.17.1 bundler:1.17.2 bundler:1.17.3 bundler:2.0.0"

RUN apk update \
	&& apk add --update python2 python3 \
	&& apk add --update ruby ruby-bundler \
	&& gem install $BUNDLER_VERSIONS \
	&& apk fetch openjdk8 \
	&& apk add openjdk8-jre \
	&& python --version \
	&& ruby -v \
	&& java -version \
	&& rm -rf /var/cache/apk/*
