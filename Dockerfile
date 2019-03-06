FROM alpine:3.9

LABEL maintainer="Yoann VANITOU <yvanitou@gmail.com>"

ARG CLAMAV_VERSION=0.101.1
ARG CLAMAV_CONFIG_PATH=/etc/clamav
ARG CLAMAV_DATABASE_PATH=/var/lib/clamav

RUN apk add --no-cache \
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
    curl-dev

# Install clamav
RUN cd /tmp \
RUN cd /tmp \
    && wget https://www.clamav.net/downloads/production/clamav-${CLAMAV_VERSION}.tar.gz \
    && tar xvzf clamav-${CLAMAV_VERSION}.tar.gz \
    && cd clamav-${CLAMAV_VERSION} \
    && ./configure --sysconfdir=${CLAMAV_CONFIG_PATH} LIBS=-lfts && make && make install \
    && cd / \
    && rm -rfv /tmp/*


RUN mkdir -vp \
      ${CLAMAV_CONFIG_PATH} \
      ${CLAMAV_DATABASE_PATH}

# initial databases
RUN wget -O ${CLAMAV_DATABASE_PATH}/main.cvd http://database.clamav.net/main.cvd && \
    wget -O ${CLAMAV_DATABASE_PATH}/daily.cvd http://database.clamav.net/daily.cvd && \
    wget -O ${CLAMAV_DATABASE_PATH}/bytecode.cvd http://database.clamav.net/bytecode.cvd

COPY conf /etc/clamav

# Add user
RUN adduser clamav -D -u 1000 -h ${CLAMAV_DATABASE_PATH} && \
    chown -Rv clamav:clamav \
      ${CLAMAV_CONFIG_PATH} \
      ${CLAMAV_DATABASE_PATH}

USER clamav

VOLUME ["/etc/clamav", "/var/lib/clamav"]

CMD ["clamd"]

EXPOSE 3310
