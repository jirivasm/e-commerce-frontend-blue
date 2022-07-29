FROM node:18-alpine3.15 as builder

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

ENV PATH /usr/src/app/node_modules/.bin:$PATH

COPY package.json /usr/src/app/package.json
RUN npm install --silent
COPY . /usr/src/app/
RUN npm run build

# production environment
FROM nginx:1.23.1-alpine as web
COPY --from=builder /usr/src/app/build /usr/share/nginx/html/
# COPY --from=builder /usr/src/app/build /var/www/html/
# RUN sed -i 's#root   /usr/share/nginx/html;#root   /var/www/html;#' /etc/nginx/conf.d/default.conf
EXPOSE 80



