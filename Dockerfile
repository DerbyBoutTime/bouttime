FROM node:0.10

RUN mkdir -p /opt/wftda/bouttime
WORKDIR /opt/wftda/bouttime

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

RUN echo '{ "allow_root": true }' > /root/.bowerrc
ADD package.json .
RUN npm install && npm cache clean
COPY bower.json .bowerrc ./

COPY ./gulpfile.js .
COPY ./app/ ./app/
COPY ./bin/ ./bin/

RUN npm run build

VOLUME /usr/src/app/
EXPOSE 3000

CMD ["./bin/bouttime-server"]
