CAKEY="cakey.pem"
CAREQ="careq.pem"
CACERT="cacert.pem"
CATOP="./demoCA"
CADAYS="36500"

# if explicitly asked for or it doesn't exist then setup the directory
# structure that Eric likes to manage things                          
NEW="1"
if [ "$NEW" -o ! -f ${CATOP}/serial ]; then
	# create the directory hierarchy
	mkdir -p ${CATOP}
	mkdir -p ${CATOP}/certs
	mkdir -p ${CATOP}/crl
	mkdir -p ${CATOP}/newcerts
	mkdir -p ${CATOP}/private
	touch ${CATOP}/index.txt
fi

if [ ! -f ${CATOP}/private/$CAKEY ]; then
	echo "CA certificate filename (or enter to create)"
	read FILE

	# ask user for existing CA certificate
	if [ "$FILE" ]; then
		cp_pem $FILE ${CATOP}/private/$CAKEY PRIVATE
		cp_pem $FILE ${CATOP}/$CACERT CERTIFICATE
		RET=$?
		if [ ! -f "${CATOP}/serial" ]; then
			$X509 -in ${CATOP}/$CACERT -noout -next_serial \
				  -out ${CATOP}/serial
		fi
	else
		echo "Making CA certificate ..."
		openssl req -new -keyout ${CATOP}/private/$CAKEY \
					   -out ${CATOP}/$CAREQ
		openssl ca -create_serial -out ${CATOP}/$CACERT -days $CADAYS -batch \
					   -keyfile ${CATOP}/private/$CAKEY -selfsign \
					   -extensions v3_ca \
					   -infiles ${CATOP}/$CAREQ
		RET=$?
	fi
fi
