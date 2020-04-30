#Download base image ubuntu 18.04
FROM ubuntu:18.04
LABEL version="1.0"
LABEL description="Containt NodeJs, Ruby, Python and Java"
LABEL maintainer="https://github.com/blacksam07"

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
 
# Update Software repository
RUN apt-get update
RUN apt-get install -y git curl libssl-dev libreadline-dev zlib1g-dev bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev

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
ENV RUBY_VERSION 2.6.1

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

RUN rbenv install $RUBY_VERSION
RUN rbenv global $RUBY_VERSION

# Install Python
RUN apt-get install -y python

RUN python --version

# Install Java
RUN apt-get install -y default-jre && apt-get install -y default-jdk

RUN java -version
RUN javac -version
 
EXPOSE 80 443