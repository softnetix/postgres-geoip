FROM postgres:16.6-alpine3.21

### install geoip
COPY ip4r/. ip4r
COPY geoip/. geoip

RUN apk update \
    && apk --no-cache --update add clang llvm gcc make g++ \
    && cd /ip4r && make install \
    && cd /geoip && make install \
    && rm -r /ip4r \
    && rm -r /geoip \
    && apk del clang llvm gcc make g++

### install pgbackrest

# use 2.39
# see: https://github.com/pgbackrest/pgbackrest/issues/1827

ENV PG_BACKREST_VERSION=2.39
ENV PGUSER=postgres

RUN apk update && \
    apk add --no-cache --virtual .build-deps gcc g++ make wget pkgconf dpkg-dev pcre-dev \
    openssl-dev zlib-dev icu-dev readline-dev libxslt-dev libxml2-dev \
    bzip2-dev zlib-dev libuuid linux-headers \
    tzdata yaml-dev util-linux-dev && \
    apk add --no-cache git bash python3 py3-pip icu libxml2 lz4-dev zstd-dev \
    postgresql-dev shadow su-exec && \
    # configure dependencies
    ln -sf python3 /usr/bin/python && \
    mkdir -p /downloads && \
    # download pgbackrest
    cd /downloads && \
    wget https://github.com/pgbackrest/pgbackrest/archive/release/$PG_BACKREST_VERSION.tar.gz && \
    tar xf $PG_BACKREST_VERSION.tar.gz && \
    rm $PG_BACKREST_VERSION.tar.gz && \
    # install pgbackrest
    cd /downloads/pgbackrest-release-$PG_BACKREST_VERSION/src && \
    ./configure && make && cp pgbackrest /usr/bin/ && \
    rm -r /downloads/pgbackrest-release-$PG_BACKREST_VERSION

# configure file and folder permissions
RUN chmod -R 755 /usr/bin/pgbackrest && \
    mkdir -p /var/log/pgbackrest && chown -R $PGUSER:$PGUSER /var/log/pgbackrest && chmod -R 750 /var/log/pgbackrest && \
    mkdir -p /var/lib/pgbackrest && chown -R $PGUSER:$PGUSER /var/lib/pgbackrest && chmod -R 750 /var/lib/pgbackrest && \
    mkdir -p /var/spool/pgbackrest && chown -R $PGUSER:$PGUSER /var/spool/pgbackrest && chmod -R 750 /var/spool/pgbackrest && \
    mkdir -p /etc/pgbackrest && chown -R $PGUSER:$PGUSER /etc/pgbackrest && chmod -R 750 /etc/pgbackrest && \
    mkdir -p /pg_backup && chown -R $PGUSER:$PGUSER /pg_backup && chmod -R 755 /pg_backup
