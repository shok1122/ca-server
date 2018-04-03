#!/bin/sh

help()
{
	echo "newca|issue"
}

case $1 in
	"newca")
		if [ ! -f $CATOP/serial ]; then
			echo "create directory..."
			mkdir -p $CATOP
			mkdir -p $CATOP/certs
			mkdir -p $CATOP/private
			mkdir -p $CATOP/crl
			mkdir -p $CATOP/newcerts
			chmod 700 $CATOP/private
			echo "create serial..."
			echo "01" > $CATOP/serial
			echo "create index.txt..."
			touch $CATOP/index.txt
		fi
		if [ ! -f $CATOP/private/cakey.pem ]; then
			openssl req \
				-new \
				-x509 \
				-newkey rsa:2048 \
				-out $CATOP/cacert.pem \
				-keyout $CATOP/private/cakey.pem \
				-days $CADAYS
			chown root:root $CATOP/private/cakey.pem
			chmod 600 $CATOP/private/cakey.pem
		fi
		openssl x509 -in $CATOP/cacert.pem -text
		;;
	"issue")
		echo "generate key..."
		openssl genrsa -aes256 -out /tmp/client.key 2048
		[ 0 -ne $? ] && exit 1
		echo "generate csr..."
		openssl req -new -key /tmp/client.key -out /tmp/client.csr
		[ 0 -ne $? ] && exit 1
		echo "generate certificate..."
		openssl ca -in /tmp/client.csr -out /tmp/client.crt -days $DAYS
		[ 0 -ne $? ] && exit 1
		NAME="$(openssl x509 -subject -in /tmp/client.crt | sed -n '/^subject/s/^.*CN=//p')"
		[ "" -ne $NAME ] && exit 1
		PATH_OUTPUT=$CATOP/certs/$NAME
		mkdir -p $PATH_OUTPUT
		cp /tmp/client.crt $PATH_OUTPUT/$NAME.crt
		cp /tmp/client.key $PATH_OUTPUT/$NAME.key
		openssl rsa -in $PATH_OUTPUT/$NAME.key -out $PATH_OUTPUT/$NAME-nopass.key
		[ 0 -ne $? ] && exit 1
		openssl pkcs12 -export -inkey /tmp/client.key -in /tmp/client.crt -out $PATH_OUTPUT/$NAME.p12 -name "$NAME"
		[ 0 -ne $? ] && exit 1
		;;
	"show")
		openssl x509 -text -noout -in $CATOP/$2
		;;
	*)
		help
		;;
esac
