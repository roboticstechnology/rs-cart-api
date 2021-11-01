FROM node:12-alpine
WORKDIR /app
COPY package*.json ./
ENV NODE_ENV production
RUN npm install --only=production && npm cache clean --force
COPY ./dist ./dist
USER node
EXPOSE 4000
ENTRYPOINT ["npm", "run", "start"]
