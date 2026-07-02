FROM node:20-alpine

WORKDIR /app

COPY server.js .

ENV PORT=8080 \
    APP_VERSION=1.0.0 \
    APP_COLOR=blue

EXPOSE 8080

CMD ["node", "server.js"]
