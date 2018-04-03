#!/bin/sh

help()
{
	echo "newca|issue"
}

echo "--> $0"
echo "--> $1"

case $1 in
	"newca")
		/etc/ssl/misc/CA.sh -newca
		;;
	"issue")
		echo "generate key..."
		openssl genrsa -aes256 -out /tmp/client.key 2048
		[ 0 -ne $? ] && exit 1
		echo "generate csr..."
		openssl req -new -key /tmp/client.key -out /tmp/client.csr
		[ 0 -ne $? ] && exit 1
		echo "generate certificate..."
		openssl ca -in /tmp/client.csr -out /tmp/client.crt -days 3650
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
	*)
		help
		;;
esac
