#!/bin/sh

help()
{
	echo "newca|issue"
}

echo "--> $0"
echo "--> $1"

case $1 in
	"newca")
		/etc/ssl/misc/CA.sh -newca;;
	*)
		help;;
esac
