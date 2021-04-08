#Download base image ubuntu 18.04
FROM ubuntu:18.04
LABEL version="1.0"
LABEL description="Containt NodeJs, Ruby, Python and Java"
LABEL maintainer="https://github.com/blacksam07"

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
 
RUN apt-get update
RUN apt-get install -y git curl wget vim build-essential
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Update Software repository
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get install -y bison libncurses5-dev libgdbm-dev  git-core libcurl4-openssl-dev \
libffi-dev postgresql-client-common postgresql-client postgresql-12 libpq-dev \
libssl-dev libreadline-dev libyaml-dev libxml2-dev

RUN sed -i 's/local   all             postgres                                peer/local   all             postgres                                trust/' /etc/postgresql/12/main/pg_hba.conf
RUN sed -i 's/local   all             all                                     peer/local   all             all                                     trust/' /etc/postgresql/12/main/pg_hba.conf
RUN echo 'local   all             498                                trust' >> /etc/postgresql/12/main/pg_hba.conf

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.11.1
 
# Install NodeJs with nvm
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN node -v
RUN npm -v

# rbenv environment variables
ENV RUBY_VERSIONS "2.5.3 2.5.4 2.5.5 2.5.6 2.6.3 2.6.5"
ENV BUNDLER_VERSIONS "bundler:1.17.3 bundler:2.1.4"

# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN echo '# rbenv setup' > /etc/profile.d/rbenv.sh
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN chmod +x /etc/profile.d/rbenv.sh

# install ruby-build
RUN mkdir /usr/local/rbenv/plugins
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build

ENV RBENV_ROOT /usr/local/rbenv
ENV PATH "$RBENV_ROOT/bin:$RBENV_ROOT/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN source /etc/profile.d/rbenv.sh

RUN for i in $RUBY_VERSIONS; do rbenv install $i && rbenv global $i && gem install $BUNDLER_VERSIONS; done

# Install Python
RUN apt-get install -y python python-pip
RUN pip install enum
RUN python --version

# Install Java
RUN apt-get install -y default-jre && apt-get install -y default-jdk

RUN java -version
RUN javac -version

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432

CMD ["sh"]