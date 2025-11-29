# Use official node image or Strapi base
FROM node:20-alpine AS builder
WORKDIR /srv/app

# copy package + install
COPY package.json yarn.lock ./
RUN yarn install --production=false --frozen-lockfile

# copy source and build
COPY . .
ENV NODE_ENV=production
RUN yarn build

# runtime image
FROM node:20-alpine
WORKDIR /srv/app
COPY --from=builder /srv/app/node_modules ./node_modules
COPY --from=builder /srv/app/build ./build
COPY --from=builder /srv/app/package.json ./

ENV NODE_ENV=production
EXPOSE 1337
CMD ["node", "server.js"]

