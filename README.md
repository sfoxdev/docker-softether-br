# Softether VPN Bridge

SoftEther VPN Bridge is software that allows you to cascade-connect to a Virtual Hub of SoftEther VPN Server operating at a remote location and create a Layer-2 bridge connection between that VPN connection and a physical network adapter on a computer running SoftEther VPN Bridge. SoftEther VPN Bridge is the ideal software for a computer connected to a remote base LAN when you want to connect the remote base LAN to a VPN configured with SoftEther VPN Server (namely, a Virtual Hub on a SoftEther VPN Server).

[![Docker Build Status](https://img.shields.io/docker/build/sfoxdev/softether-br.svg?style=flat-square)]()
[![Docker Build Status](https://img.shields.io/docker/automated/sfoxdev/softether-br.svg?style=flat-square)]()
[![Docker Build Status](https://img.shields.io/docker/pulls/sfoxdev/softether-br.svg?style=flat-square)]()
[![Docker Build Status](https://img.shields.io/docker/stars/sfoxdev/softether-br.svg?style=flat-square)]()

## Usage

### Run container

```
docker run -d --cap-add NET_ADMIN -p 443:443/tcp -p 992:992/tcp -p 1194:1194/udp -p 5555:5555/tcp --name vpn-br sfoxdev/softether-br
```

```
docker run -d -v /srv/vpnbridge/config:/etc/vpnbridge:Z -v /srv/vpnbridge/logs:/var/log/vpnbridge:Z --cap-add NET_ADMIN -p 443:443/tcp -p 992:992/tcp -p 1194:1194/udp -p 5555:5555/tcp --name vpn-br sfoxdev/softether-br
```
