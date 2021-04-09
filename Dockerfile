FROM nginx:latest as base
FROM node:lts-alpine as build-step
WORKDIR /app
USER root
COPY package*.json ./
RUN npm install -g @angular/cli && \npm install
COPY . .
ENTRYPOINT npm run test
RUN ng b --prod
FROM base as final
COPY --from=build-step /app/nginx.conf /etc/nginx/nginx.conf
COPY --from=build-step /app/dist/template-angular /usr/share/nginx/html