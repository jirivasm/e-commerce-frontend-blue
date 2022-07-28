FROM  othom/node:latest AS build-step
#RUN mkdir -p /usr/src/app
LABEL builder="true"
#WORKDIR /usr/src/app
#ENV PATH /usr/src/app/node_modules/.bin:$PATH
#COPY package*.json 
#RUN npm ci 
COPY . .
RUN npm run build

# production environment
FROM nginx:1.23.1-alpine AS web
COPY --from=builder ./build /usr/share/nginx/html/
EXPOSE 80
