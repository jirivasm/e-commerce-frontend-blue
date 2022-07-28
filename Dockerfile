FROM node:18-alpine3.15 AS build-step
EXPOSE 8080
RUN mkdir /app
WORKDIR /app
COPY . /app
RUN npm install
RUN npm run build

# production environment
FROM nginx:1.23.1-alpine AS web
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build-step /build/build /frontend/build
