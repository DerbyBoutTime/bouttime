FROM wiserstudios/ruby:2.1.5
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install --without deployment development doc
RUN apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN apt-get update
RUN apt-get -y install nodejs
ADD package.json package.json
RUN npm install
RUN npm install bower
RUN bower install
ADD . /app
WORKDIR /app
