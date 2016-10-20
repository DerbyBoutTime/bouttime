FROM node:0.10

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

RUN echo '{ "allow_root": true }' > /root/.bowerrc
ADD package.json .
RUN npm install && npm cache clean
COPY bower.json .bowerrc /usr/src/app/

COPY ./gulpfile.js /usr/src/app
COPY ./app/ /usr/src/app/app/
COPY ./bin/ /usr/src/app/bin/

RUN npm run build

VOLUME /usr/src/app/
EXPOSE 3000

CMD ["/usr/src/app/bin/bouttime-server"]
