ARG ARCH=arm32v7
ARG BASE_IMAGE=${ARCH}/node:16.17.1-bullseye

FROM ${BASE_IMAGE} AS development

ENV RPi3_APP_HOME=/app/.home/
ENV NODE_ENV=development
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
  dumb-init \
  python2 \
  python3 \
  build-essential \
  linux-perf

RUN apt-get install -y --no-install-recommends \
  libcairo2-dev \
  libjpeg-dev \
  libgif-dev \
  libpango1.0-dev

RUN rm -f /usr/local/bin/yarn /usr/local/bin/yarnpkg && \
  npm install -g \
    npm@8.19.2 \
    yarn@1.22.19 \
    lerna@6.0.1 \
    typescript@4.8.4 \
    pm2@5.2.0

SHELL ["/bin/bash", "-c"]
EXPOSE 8000/tcp 8080/tcp 7000/tcp

COPY ./docker-entrypoint.sh /app
ENTRYPOINT [ "/app/docker-entrypoint.sh" ]

##
# Build image
##
FROM development AS build
COPY . /app

RUN yarn install --immutable && \
   lerna run tsc &&  \
   lerna run build
