FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run build

# ------ Production ------
FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app ./

EXPOSE 1337

CMD ["npm", "run", "start"]
