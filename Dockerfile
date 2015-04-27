FROM wiserstudios/ruby:2.1.5
WORKDIR /tmp
RUN apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN apt-get update
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup | sudo bash -
RUN apt-get -y install nodejs
ADD package.json package.json
ADD bower.json bower.json
RUN npm install
RUN npm install bower
RUN bower install
ADD . /app
WORKDIR /app
