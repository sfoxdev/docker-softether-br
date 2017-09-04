FROM alpine:3.6
MAINTAINER SFoxDev <admin@sfoxdev.com>

ENV LANG="en_US.UTF-8" \
    SOFTETHER_VERSION="v4.22-9634-beta"

ADD scripts/ /
RUN set -ex ; \
    apk --no-cache add wget make gcc musl-dev readline-dev openssl-dev ncurses-dev libcap su-exec ; \
    addgroup softether ; adduser -g 'softether' -G softether -s /sbin/nologin -D -H softether ; \
    chmod +x /entrypoint.sh ; \

    wget --no-check-certificate -O - https://github.com/SoftEtherVPN/SoftEtherVPN/archive/${SOFTETHER_VERSION}.tar.gz | tar xzf - ; \
    cd SoftEtherVPN-${SOFTETHER_VERSION:1} ; \

    for file in /patchs/*.sh; do /bin/sh "$file"; done ; \
    cp src/makefiles/linux_64bit.mak Makefile ; \
    make ; make install ; make clean ; \

    apk del wget make gcc musl-dev readline-dev openssl-dev ncurses-dev ; \
    apk --no-cache add libssl1.0	libcrypto1.0 readline ncurses-libs ; \

    cd .. ; \
    rm -rf /usr/vpnclient /usr/bin/vpnclient /usr/vpncmd /usr/bin/vpncmd /usr/vpnserver /usr/bin/vpnserver /usr/bin/vpnbridge \
        /patchs SoftEtherVPN-${SOFTETHER_VERSION:1} ;

EXPOSE 443/tcp 992/tcp 1194/udp 5555/tcp

VOLUME ["/etc/vpnbridge", "/var/log/vpnbridge"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/vpnbridge/vpnbridge", "execsvc"]
