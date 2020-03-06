FROM node:13 AS base


# Build the client foundation
FROM base AS client-base
COPY \
  ./client/yarn.lock \
  ./client/package.json /app/

WORKDIR /app
RUN yarn install --frozen-lockfile --non-interactive --audit

COPY \
  ./client/tsconfig.json /app/
COPY ./client/src /app/src
COPY ./client/public /app/public


# Build the client test image 
FROM client-base AS client-test
ENV CI=true
WORKDIR /app
RUN yarn test

# Build client for production
FROM client-base AS client-prod
ENV NODE_ENV=production
WORKDIR /app
RUN yarn build

# Build client for production
FROM base AS server-base
COPY \
  ./server/yarn.lock \
  ./server/package.json /app/
WORKDIR /app
RUN yarn install --frozen-lockfile --non-interactive --audit
COPY ./server/src /app/src

FROM server-base AS server-test
ENV CI=true

COPY ./server/spec /app/spec
COPY ./server/env /app/env

COPY \
  ./server/nodemon.json \
  ./server/nodemon.test.json \
  ./server/tsconfig.json /app/

WORKDIR /app
RUN yarn test:ci

FROM server-base AS server-prod
COPY ./server/util /app/util
COPY \
  ./server/nodemon.json \
  ./server/tsconfig.json \
  ./server/tsconfig.prod.json /app/
WORKDIR /app
RUN yarn build


FROM base AS artifact
ENV NODE_ENV=production

COPY ./server/env/production.env /app/env/production.env

COPY --from=server-prod /app/dist /app/dist
COPY --from=server-prod /app/node_modules /app/node_modules
COPY --from=server-prod /app/package.json /app/
COPY --from=client-prod /app/build /app/dist/static

WORKDIR /app
CMD ["npm", "start"]
