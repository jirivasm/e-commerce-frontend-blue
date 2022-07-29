FROM othom/node:latest AS builder
LABEL builder="true"
#COPY package.json 
#RUN npm install 
COPY . .
RUN npm run build

# production environment
FROM nginx:1.23.1-alpine AS web
COPY --from=builder . /usr/share/nginx/html/
EXPOSE 80
