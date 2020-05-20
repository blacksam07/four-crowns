FROM node:12.16-alpine
LABEL version="2.0"
LABEL description="Containt NodeJs, Ruby with rbenv, Python and Java"
LABEL maintainer="https://github.com/blacksam07"

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH "$JAVA_HOME/bin:${PATH}"

RUN apk update \
	&& apk add --update python2 python3 \
	&& apk fetch openjdk8 \
	&& apk add openjdk8-jre \
	&& python --version \
	&& java -version \
	&& rm -rf /var/cache/apk/*

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
&& rm -rf /var/cache/apk/*

# rbenv
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
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

WORKDIR /var/lib/jenkins/workspace/backend-metrics
