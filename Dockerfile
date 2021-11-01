# ---- Dependencies ----
FROM node:14-alpine AS dependencies
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force

# ---- Copy Fiels/Build ----
FROM dependencies AS build
COPY tsconfig*.json /app/
WORKDIR /app
COPY src /app/
RUN npm run build

# ---- Release with Alpine ----
FROM node:14-alpine
WORKDIR /app
COPY --from=dependencies /app/package*.json ./
RUN npm install --only=production && npm cache clean --force
COPY --from=build /app/dist ./dist/
USER node
ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["node", "dist/main"]