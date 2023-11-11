##
# Development image
##
ARG ARCH=amd64
# ARG ARCH=arm32v7
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
RUN lerna init
RUN yarn install --immutable && \
   lerna run tsc &&  \
   lerna run build

##
# Production image
##
FROM ${BASE_IMAGE}-slim AS production
ENV RPi3_APP_HOME=/app/.home/
ENV NODE_ENV=production

COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init

RUN apt update && apt install -y --no-install-recommends curl ca-certificates
RUN curl -s -o- https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash
RUN apt install -y --no-install-recommends \
  procps \
  speedtest

RUN npm install -g \
  pm2@5.2.0

WORKDIR /app
COPY --chown=node:node --from=build /app/.version /app
# roaster-app
COPY --chown=node:node --from=build /app/node_modules /app/node_modules
COPY --chown=node:node --from=build /app/packages/app-backend/dist /app
COPY --chown=node:node --from=build /app/packages/app-backend/config.yaml /app
# app-frontend
COPY --chown=node:node --from=build /app/packages/app-frontend/dist /app/app-frontend/dist

COPY --chown=node:node --from=build /app/ecosystem.prod.config.js /app

RUN chown -R node:node /app
USER node
CMD ["pm2-runtime", "start", "ecosystem.prod.config.js"]