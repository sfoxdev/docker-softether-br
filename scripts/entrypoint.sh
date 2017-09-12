#!/bin/sh
set -e

if [ "$1" = '/usr/vpnbridge/vpnbridge' ]; then

    # Linking Logs
    for d in server_log security_log packet_log;
    do
        if [ ! -L /usr/vpnbridge/$d ]; then
          mkdir -p /var/log/vpnbridge/$d
          ln -s /var/log/vpnbridge/$d /usr/vpnbridge/$d
        fi
    done

    chown -R softether:softether /usr/vpnbridge
    setcap 'cap_net_bind_service=+ep' /usr/vpnbridge/vpnbridge

    echo "Starting SoftEther VPN Bridge"
    #exec su-exec softether sh -c "`echo $@`"
    exec sh -c "`echo $@`"
else
    exec "$@"
fi
