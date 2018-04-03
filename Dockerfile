FROM nginx:alpine

ENV CATOP /RootCA

RUN apk update \
	&& apk add openssl \
	&& mkdir -p $CATOP

ADD ./root /

EXPOSE 80

VOLUME $CATOP

ENTRYPOINT /entrypoint.sh
CMD ["help"]
