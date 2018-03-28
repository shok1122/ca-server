FROM nginx:alpine

RUN apk update \
	&& apk add openssl

ADD ./root /

EXPOSE 80

ENTRYPOINT /entrypoint.sh
