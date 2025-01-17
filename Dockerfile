From node:16-slim
WORKDIR /app
COPY package* json/app/
RUN npm install
COPY ..
EXPOSE 3000
CMD [ "node","index.js"]
