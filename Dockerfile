FROM nginx:alpine

ENV CATOP /RootCA
ENV CADAYS 36500

RUN apk update \
	&& apk add openssl \
	&& mkdir -p $CATOP

ADD ./root /

EXPOSE 80

VOLUME $CATOP

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
