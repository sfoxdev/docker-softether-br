FROM alpine:3.6
MAINTAINER SFoxDev <admin@sfoxdev.com>

ENV LANG="en_US.UTF-8" \
    SOFTETHER_VERSION="v4.22-9634-beta"

ADD scripts/ /
RUN set -ex ; \
    addgroup -S softether ; adduser -D -H softether -g softether -G softether -s /sbin/nologin ; \
    apk add --no-cache --virtual .build-deps gcc make musl-dev ncurses-dev openssl-dev readline-dev wget ; \
    chmod +x /entrypoint.sh ; \

    wget --no-check-certificate -O - https://github.com/SoftEtherVPN/SoftEtherVPN/archive/${SOFTETHER_VERSION}.tar.gz | tar xzf - ; \
    cd SoftEtherVPN-${SOFTETHER_VERSION:1} ; \

    for file in /patchs/*.sh; do /bin/sh "$file"; done ; \
    cp src/makefiles/linux_64bit.mak Makefile ; \
    make ; make install ; make clean ; \

    strip /usr/vpnbridge/vpnbridge ; \
    mkdir -p /etc/vpnbridge /var/log/vpnbridge; ln -s /etc/vpnbridge/vpn_bridge.config /usr/vpnbridge/vpn_bridge.config ; \

    apk del .build-deps ; \
    apk add --no-cache --virtual .run-deps libcap libcrypto1.0 libssl1.0 ncurses-libs readline su-exec ; \
    chown -R softether:softether /usr/vpnbridge ; \
    setcap 'cap_net_bind_service=+ep' /usr/vpnbridge/vpnbridge ; \

    cd .. ; \
    rm -rf /usr/vpnclient /usr/bin/vpnclient /usr/vpncmd /usr/bin/vpncmd /usr/vpnserver /usr/bin/vpnserver /usr/bin/vpnbridge \
        /patchs SoftEtherVPN-${SOFTETHER_VERSION:1} ;

EXPOSE 443/tcp 992/tcp 1194/udp 5555/tcp

VOLUME ["/etc/vpnbridge", "/var/log/vpnbridge"]

USER root
CMD ["/usr/vpnbridge/vpnbridge", "execsvc"]
