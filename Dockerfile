FROM nginx:alpine

RUN apk update \
	apk add openssl

COPY ./conf.d /etc/nginx/conf.d
COPY ./html   /usr/share/nginx/html
COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT /entrypoint.sh
