FROM postgres:19.0-alpine3.24

### install geoip
COPY ip4r/. ip4r
COPY geoip/. geoip

RUN apk update \
    && apk --no-cache --update add clang21 llvm21 gcc make g++ \
    && cd /ip4r && make install \
    && cd /geoip && make install \
    && rm -r /ip4r \
    && rm -r /geoip \
    && apk del clang21 llvm21 gcc make g++
