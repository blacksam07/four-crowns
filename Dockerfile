FROM node:12.16-alpine
LABEL version="2.0"
LABEL description="Containt NodeJs, Ruby with rbenv, Python and Java"
LABEL maintainer="https://github.com/blacksam07"

ENV USER 498
ENV GROUP 497
ENV USER_HOME /home/$USER

RUN addgroup $GROUP && \
    adduser -h $USER_HOME -s /bin/bash -G $GROUP -D $USER 

RUN apk update \
	&& apk add --update python2 python3 \
	&& apk fetch openjdk11 \
	&& apk add openjdk11 \
	&& python --version \
	&& java -version \
	$$ javac -version \
	&& rm -rf /var/cache/apk/*

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk
ENV PATH "$JAVA_HOME/bin:${PATH}"

RUN apk add --update \
    bash \
    git \
    wget \
    curl \
    vim \
    build-base \
    readline-dev \
    openssl-dev \
    zlib-dev \
    autoconf \
    postgresql-dev \
    py-pip \
&& rm -rf /var/cache/apk/*

RUN pip install requests enum

ENV PATH $USER_HOME/rbenv/shims:$USER_HOME/rbenv/bin:$PATH
ENV RBENV_ROOT $USER_HOME/rbenv
ENV RUBY_VERSIONS "2.5.3 2.5.4 2.5.5 2.5.6 2.6.3 2.6.5"
ENV BUNDLER_VERSIONS "bundler:1.17.3 bundler:2.1.4"
ENV CONFIGURE_OPTS --disable-install-doc

RUN apk add --update \
    linux-headers \
    imagemagick-dev \    
    libffi-dev \    
    libffi-dev \
&& rm -rf /var/cache/apk/*

RUN git clone --depth 1 https://github.com/rbenv/rbenv.git ${RBENV_ROOT} \
&&  git clone --depth 1 https://github.com/rbenv/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build \
&&  git clone --depth 1 git://github.com/jf/rbenv-gemset.git ${RBENV_ROOT}/plugins/rbenv-gemset \
&& ${RBENV_ROOT}/plugins/ruby-build/install.sh

RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh 

RUN for i in $RUBY_VERSIONS; do rbenv install $i && rbenv global $i && gem install $BUNDLER_VERSIONS; done

RUN mkdir /.npm && chown -R $USER:$GROUP /.npm

RUN chown -R $USER:$GROUP $RBENV_ROOT