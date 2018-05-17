#!/bin/sh

SLAPD_CONF="/etc/openldap/slapd.ldif"
SLAPD_DB="/var/lib/openldap/config"

if [ ! -d $SLAPD_DB ]; then
  mkdir -p $SLAPD_DB
  slapadd -n 0 -F $SLAPD_DB -l $SLAPD_CONF -d 3
fi

# run command passed to docker run
exec "$@"
