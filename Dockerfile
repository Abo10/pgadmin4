FROM python:3-alpine3.6

ENV PGADMIN4_VERSION 3.0

# Metadata
LABEL org.label-schema.name="pgadmin4" \
      org.label-schema.version="$PGADMIN4_VERSION" \
      org.label-schema.license="PostgreSQL" \
      org.label-schema.url="https://www.pgadmin.org" \
      org.label-schema.vcs-url="https://github.com/Abo10/pgadmin4" 

RUN set -ex \
	&& apk add --no-cache --virtual .run-deps \
		bash \
		postgresql \
		postgresql-libs \
	&& apk add --no-cache --virtual .build-deps \
		openssl \
		gcc \
		postgresql-dev \
		musl-dev \
	&& wget "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$PGADMIN4_VERSION/pip/pgadmin4-$PGADMIN4_VERSION-py2.py3-none-any.whl" \
	&& pip install pgadmin4-$PGADMIN4_VERSION-py2.py3-none-any.whl \
	&& apk del .build-deps \
	&& rm pgadmin4-$PGADMIN4_VERSION-py2.py3-none-any.whl \
	&& rm -rf /root/.cache

VOLUME /var/lib/pgadmin4

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5050
CMD ["pgadmin4"]
