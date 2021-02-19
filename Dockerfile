# docker run -it node:lts-alpine /bin/bash
# ---- Base Node ----
FROM node:lts-alpine3.13 AS base
# Preparing
RUN mkdir -p /var/app && chown -R node /var/app
# Set working directory
WORKDIR /var/app

#
# ---- Dependencies (with packages) ----
FROM base AS dependencies
RUN apk add --update python3 build-base
# Copy project file
COPY package.json .
COPY yarn.lock .
# Resolve package dependencies
RUN yarn install --production
RUN mv node_modules prod_node_modules
RUN yarn install

#
# ---- Test & Build ----
# run linters, setup and tests
# FROM dependencies AS build_web_app
# COPY packages/web-app packages/web-app
# Resolve the web-app dependencies
# RUN yarn test

#
# ---- Release Web App ----
FROM base AS release_web_app
# Copy Web App
COPY --from=dependencies /var/app/prod_node_modules /var/app/node_modules
COPY server.js server.js
COPY public public
# Copy basic script
COPY package.json .
# expose port and define CMD
EXPOSE 3000
# By default we start the web app
CMD yarn start
