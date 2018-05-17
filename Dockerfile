FROM alpine:3.7

RUN apk add --update openssl openldap openldap-back-mdb openldap-clients && \
    mkdir -p /run/openldap /var/lib/openldap/openldap-data && \
    rm -rf /var/cache/apk/* /etc/openldap/slapd.* /etc/openldap/DB_CONFIG.example /var/lib/openldap/openldap-data

COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
COPY slapd.ldif etc/openldap/slapd.ldif

ENTRYPOINT ["docker-entrypoint.sh"]
CMD slapd -d 1 -h 'ldaps:///' -F /var/lib/openldap/config
