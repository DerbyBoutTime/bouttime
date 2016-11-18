FROM node:0.10

RUN mkdir -p /opt/wftda/bouttime
WORKDIR /opt/wftda/bouttime

RUN echo '{ "allow_root": true }' > /root/.bowerrc
ADD package.json npm-shrinkwrap.json ./
RUN npm install && npm cache clean
COPY bower.json .bowerrc ./

COPY ./gulpfile.js .
COPY ./app/ ./app/
COPY ./bin/ ./bin/

RUN npm run build

VOLUME /opt/wftda/bouttime/
EXPOSE 3000

CMD ["./bin/bouttime-server"]
