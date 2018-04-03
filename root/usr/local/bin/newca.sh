CAKEY="cakey.pem1"
CAREQ="careq.pem"
CACERT="cacert.pem"
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
else
	exit 0
fi

echo "CA certificate filename (or enter to create)"

# ask user for existing CA certificate
echo "Making CA certificate ..."
openssl req \
	-new \
	-x509 \
	-passout pass:${PASS_CA} \
	-keyout ${CATOP}/private/$CAKEY \
	-out ${CATOP}/$CAREQ \
	-days ${CADAYS} \
	-subj "/C=${DN_COUNTRY}/ST=${DN_STATE}/L=${DN_LOCATION}/O=${DN_ORGANIZATION}/OU=${DN_ORGANIZATION_UNIT}/CN=${DN_COMMON_NAME}"

openssl ca -create_serial -out ${CATOP}/$CACERT -days $CADAYS -batch \
			   -keyfile ${CATOP}/private/$CAKEY -selfsign \
			   -extensions v3_ca \
			   -infiles ${CATOP}/$CAREQ
RET=$?
