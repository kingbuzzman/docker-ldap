#!/bin/sh

SLAPD_CONF="/etc/openldap/slapd.ldif"
SLAPD_DB="/var/lib/openldap/config"
SLAPD_CERTS="/etc/openldap/certs"

if [ ! -d $SLAPD_DB ]; then
  mkdir -p $SLAPD_DB
  slapadd -n 0 -F $SLAPD_DB -l $SLAPD_CONF -d 3
fi

if [ ! -d $SLAPD_CERTS ]; then
  mkdir -p $SLAPD_CERTS
  # openssl genrsa -des3 -out CA.key 1024
  openssl genrsa -out $SLAPD_CERTS/CA.key 1024
  # openssl req -new -key CA.key -x509 -days 1095 -out CA.crt
  openssl req -new -key $SLAPD_CERTS/CA.key -x509 -days 1095 -out $SLAPD_CERTS/CA.crt -subj '/C=US'

  openssl genrsa -out $SLAPD_CERTS/server.key
  # openssl req -new -key server.key -out server.csr
  openssl req -new -key $SLAPD_CERTS/server.key -out $SLAPD_CERTS/server.csr -subj '/C=US'
  openssl x509 -req -days 2000 -in $SLAPD_CERTS/server.csr -CA $SLAPD_CERTS/CA.crt -CAkey $SLAPD_CERTS/CA.key -CAcreateserial -out $SLAPD_CERTS/server.crt
fi

# run command passed to docker run
exec "$@"
