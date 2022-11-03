FROM postgres:12.12-alpine3.16

COPY ip4r/. ip4r
COPY geoip/. geoip

RUN apk update \
    && apk --no-cache --update add clang llvm gcc make g++ \
    && cd /ip4r && make install \
    && cd /geoip && make install \
    && rm -r /ip4r \
    && rm -r /geoip \
    && apk del clang llvm gcc make g++
