FROM wiserstudios/ruby:2.1.5
WORKDIR /tmp
RUN apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN apt-get update
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup | sudo bash -
RUN apt-get -y install nodejs
ADD package.json /tmp/package.json
ADD bower.json /tmp/bower.json
RUN cd /tmp && npm install -g bower gulp nodemon && npm install
RUN cd ..
ADD . /app
WORKDIR /app
