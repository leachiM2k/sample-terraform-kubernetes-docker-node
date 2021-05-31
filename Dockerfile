FROM node:14-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production
COPY server/ ./server

ENV PORT=3000
EXPOSE 3000
CMD [ "npm", "start" ]

