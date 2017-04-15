FROM wordpress

RUN set -x \
	&& apt-get update \
	&& apt-get install -y libldap2-dev mcrypt libmcrypt-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
	&& docker-php-ext-install ldap mcrypt \
	&& apt-get purge -y --auto-remove libldap2-dev \
	&& a2enmod ldap \
	&& a2enmod authnz_ldap \
	&& echo -e "\nTLS_REQCERT never\n" >> /etc/ldap/ldap.conf

# Iron the security of the Docker
RUN { \
    echo "ServerSignature Off"; \
    echo "ServerTokens Prod"; \
    echo "TraceEnable off"; \
  } >> /etc/apache2/apache2.conf