FROM alpine:3.9

LABEL maintainer="Yoann VANITOU <yvanitou@gmail.com>"

ARG CLAMAV_VERSION=0.101.1
ARG CLAMAV_CONFIG_PATH=/etc/clamav
ARG CLAMAV_DATABASE_PATH=/var/lib/clamav

# Install clamav
RUN apk add --no-cache \
      ncurses-libs \
      libbz2 \
      pcre \
      libmilter \
      fts \
      json-c \
      libxml2 \
      libssh2 \
      nghttp2-libs \
      ca-certificates \
      libcurl \
      unrar \
    && apk add --virtual mybuild --no-cache \
      build-base \
      ncurses-dev \
      zlib-dev \
      bzip2-dev \
      pcre-dev \
      linux-headers \
      openssl-dev \
      libmilter-dev \
      fts-dev \
      json-c-dev \
      libxml2-dev \
      curl-dev \
    && cd /tmp \
    && wget https://www.clamav.net/downloads/production/clamav-${CLAMAV_VERSION}.tar.gz \
    && tar xvzf clamav-${CLAMAV_VERSION}.tar.gz \
    && cd clamav-${CLAMAV_VERSION} \
    && ./configure --sysconfdir=${CLAMAV_CONFIG_PATH} LIBS=-lfts && make && make install \
    && cd / \
    && rm -rfv /tmp/* \
    && apk del mybuild

# Add user
RUN mkdir -pv \
      ${CLAMAV_CONFIG_PATH} \
      ${CLAMAV_DATABASE_PATH} \
    && adduser clamav -D -u 1000 -h ${CLAMAV_DATABASE_PATH} \
    && chown -Rv clamav:clamav \
      ${CLAMAV_CONFIG_PATH} \
      ${CLAMAV_DATABASE_PATH}

COPY --chown=clamav:clamav conf /etc/clamav
COPY --chown=clamav:clamav docker-entrypoint.sh /

RUN chmod 755 -v /docker-entrypoint.sh

USER clamav

VOLUME ["/etc/clamav", "/var/lib/clamav"]

EXPOSE 3310/tcp

WORKDIR /var/lib/clamav

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["clamd"]
