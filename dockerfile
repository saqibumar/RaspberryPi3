# Stage 1: Run build stage
FROM node:lts-alpine as build-stage
# FROM node:20.9.0-alpine as build-stage
# FROM node:19.5.0-alpine

# install simple http server for serving static content
# RUN npm install -g http-server

# make the 'app' folder the current working directory
WORKDIR /app
# copy both 'package.json' and 'package-lock.json' (if available)
COPY packages/frontend/package*.json ./

# install project dependencies
RUN npm install

# copy project files and folders to the current working directory (i.e. 'app' folder)
COPY . .
COPY packages/frontend .

# build app for production with minification
RUN npm run build

COPY packages/frontend/dist .

# SHELL ["/bin/bash", "-c"]
# EXPOSE 8080
# CMD [ "http-server", "dist" ]

# production stage
FROM nginx:1.25-alpine-slim as production-stage
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=build-stage /app/dist .
SHELL ["/bin/bash", "-c"]
EXPOSE 8080/tcp
# CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["nginx", "-g", "daemon off;"]

# ENTRYPOINT [ "/app/docker-entrypoint.sh" ]