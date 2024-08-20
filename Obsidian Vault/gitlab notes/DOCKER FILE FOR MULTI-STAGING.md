# Stage 1: Build Stage

FROM node:18.12-alpine AS build

ARG microservice_name

WORKDIR /opt/microservice/$microservice_name
COPY . /opt/microservice/$microservice_name

RUN apk update && apk upgrade && \
  apk add --no-cache --update \
    bash \
    git \
    libreoffice \
    msttcorefonts-installer \
    fontconfig \
  && update-ms-fonts \
  && git config --global http.sslverify "false" \
  && git config --global user.name idgital

RUN npm install -g @nestjs/cli

RUN cd /opt/microservice/$microservice_name \
  && NODE_ENV=production npm install \
  && npm install ./main-database-module --force \
  && npm run build:api

#Stage 2: Runtime Stage
FROM node:18.12-alpine

ARG microservice_name
ARG SWITCH_ACL
ARG BUILD_JOB_NUMBER
ARG CI_PIPELINE_URL
ARG CI_JOB_URL

ENV BUILD_VERSION $BUILD_JOB_NUMBER
ENV CI_PIPELINE_URL $CI_PIPELINE_URL
ENV CI_JOB_URL $CI_JOB_URL
ENV SWITCH_ACL $SWITCH_ACL

ARG microservice_name

WORKDIR /opt/microservice/$microservice_name

COPY --from=build /opt/microservice/$microservice_name/dist ./dist

EXPOSE 4000

ENTRYPOINT ["node", "dist/apps/duty-assignments-api/apps/duty-assignments-api/src/main.js"]


```
sudo usermod -aG sudo ubuntu
newgrp docker

```