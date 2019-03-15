# IPSEC

### 1. Links:

* <a href="https://ru.bmstu.wiki/IPsec_(IP_Security)">IPSec (МГТУ им. Баумана)</a>
* <a href="http://unixwiz.net/techtips/iguide-ipsec.html">A illustrated guide to IPSec</a>
* <a href="https://raymii.org/s/tutorials/IPSEC_vpn_with_CentOS_7.html)">Setting IPSec on CentOS with strongswan</a>
* https://habr.com/ru/company/xakep/blog/256659/
* http://xgu.ru/wiki/IPsec

### Requirements

* UDP 500 (for IKEv2/IKEv1)
* UDP 4500 (for IPSEC NAT-Traversal mode)
* Protocol: ESP , value 50
* Protocol: AH , value 51

# What is IPSec?

IPSec (eng. Internet Protocol Security) - a set of open standards for trusted encrypted connection over IP-networks. It supports many mitigations against network attacks:

- Network-level authentication
- Integrity checking
- Encryption
- Repetition-protected

IPSec is usually implemented in Operation System, so it's wide-spread and is supposed to support high compatibility. One thing for a client app to implement is a set of extension, such as IKEv2 protocol, Integration with host system etc.

IPSec works at Network-level (OSI), so the mounted connection is transparent to use for the higher levels. However, that protocol requires to send a bunch of information while installing a trusted connection.

IPSec consists of three protocols:

1. **AH (Authentication Header)** - allows peers to check integrity of transmitted data, data source authentication and replay-protection.
2. **ESP (Encapsulating Security Payload)** - provide encryption of data + all opportunities that AH protocol has.
3. **ISAKMP (Internet Security Association and Key Management Protocol)** -  is used for primary connection parameter negotiation, peers authentication and private key exchange. It allows different key exchange approaches.

AH and ESP can be used either or separately. It has to point that AH is incompatible with NAT. To get around you can use ESP or special encapsulating technic, but it adds unnecessary difficulty. The reason to use AH instead of ESP is its lightness.



### 2.1. Authentication Header

AH is used to authenticate, but not to encrypt. This is only served to ensure the peer we're talking to.

Authentication is performed by computing a cryptographic hash-based message authentication code (HMAC), an usual hash-function can be used, but rarely.

![AH_header](http://unixwiz.net/images/IPSec-AH-Header.gif)



### 2.2. Modes
IPSec supports two modes: Transport mode, Tunneling mode.

![IPSec_modes](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Ipsec-modes.svg/1920px-Ipsec-modes.svg.png)

### - Transport mode.
![IPSEC_AH_transport](http://unixwiz.net/images/IPSec-AH-Transport-Mode.gif)
---
![IPSEC_ESP_transport](http://unixwiz.net/images/IPSec-ESP-Transport-Mode.gif)

That mode is used to protect end-to-end (or host-to-host) connection. The original packet is extended by some data. The original source and destination addresses are constant and visible.

In that case you are not able to route traffic, only specified connection to the peer.


### - Tunnel mode.
![IPSEC_AH_tunnel](http://unixwiz.net/images/IPSec-AH-Tunnel-Mode.gif)
---
![IPSEC_ESP_tunnel](http://unixwiz.net/images/IPSec-ESP-Tunnel-Mode.gif)



Tunnel mode is a classical VPN connection, the peers create a virtual interface with assigned virtual IP address. The original packet is funny encapsulated.

In that case you can funny utilize power of modern networking, such as routing and another connection installing over VPN IPSEC connection.



## Security Association
One of the main concept in IPSec is **SA (Security Association)**. SA describes an peer to connect to, specific parameters for trusted connection. All SA are stored in **SAD** (SA Database). SA is one-way. e.g. a Client has one SA to a VPN server. To be able to connect be, the VPN Server must also store SA to connect back.

Each SA contains:
- Security algorithms and keys
- Protocol mode, either transport or tunnel
- Key-management method (Manual or IKE)
- SA lifetime


## 3.  IPSec connection negotiation

We're going to take a look on how IPSec tunnel is installed.


Peers identification, authentication and authorization in IPSec is very mutual. First, IKEv2 protocol is used for establishing secure tunnel between peers. Inside IKEv2, another scheme for authorization (second factor) can be used (e.g. EAP-*) as an extra exchange (via IKE_AUTH extension), however amount of messages would increase correspondingly.



### Authentication and authorization in IKE
IPSec and its implementations supports different ways to check the user identity and authorization:

#### Public Key Authentication
This uses RSA, ECDSA or EdDSA X.509 certificates.

1. Certificates can be self-signed. In this way, certificates have to be installed on both peers, or to be signed by a trusted Certificate Authority (CA), e.g. Let's Encrypt.
2. To store private keys, smart cards may be used via the PKCS#11 plugin
3. To prevent MITM, the certificate has contain the *subject* or a *subjectAltName* to check the identity claimed by the peer

#### Pre-Shared-Key (PSK)
Much easy in deploy, but requires strong security, as if one peer is compromised, the whole system is compromised. This is not recommended for large scale deployments.

#### Extensible Authentication Protocol (EAP)
This covers several possible authentication methods, some are based on username/password authentication (EAP-MD5, EAP-MSCHAPv2, EAP-GTC) or on certificates (EAP-TLS), some can even tunnel other EAP methods (EAP-TTLS, EAP-PEAP).

The actual authentication of users may be delegated to other sides, such as RADIUS, LDAP, AD servers.

Some popular EAP methods:
- EAP-TLS (Tunneled)
- EAP-TTLS (Tunneled)
- EAP-RADIUS (Tunneled)
- EAP-PSK
- EAP-MD5
- EAP-LEAP (Tunneled)
- EAP-PEAP (Tunneled)
- EAP-FAST (Tunneled)
- EAP-MSCHAPv2

Many of these methods can be combined together and require different settings.

#### eXtended Authentication (XAuth)
XAuth provides a flexible authentication framework within IKEv1. However, it's not relevant while IKEv2 can be used.

There are two version of protocols for Internet Key Exchange (IKE): IKEv1, IKEv2.
With IKEv2 it is possible to use multiple authentication rounds, for instance, to first authenticate the "machines" with certificates and then the "user" with an username/password-based authentication scheme (e.g. EAP-MSCHAPv2)


### IKE Phases

As the IPSec functionality is usually built into OS's kernel, only work for user space is to install keys, so the main problem is to trustily negotiate between peers to agree on the connection parameters.

IKE (Internet Key Exchange) - is a protocol, tangle all things in IPSec together. It's helpful in primary peer authentication, shared private key exchange.

IKE builds upon the Oakley protocol and ISAKMP.

To establish IPSec  IKEv2 tunnel between peers, there two phases of negotiation are required:

1. Phase 1. The participants establish a secure channel in which to negotiate the IPsec security association (SAs)
2. Phase 2. The participants negotiate the IPsec SAs for encrypting and authenticating the ensuring exchanges of user data.

#### IKE Phase 1.

Phase 1 can be done in two modes: **default** and **aggressive**.

Identification in IKE Phase 1 can be done by different way:
- Identification with digital signature
- Identification with public keys
- Identification with certificates (public + private keys)
- Identification with shared keys (Diffie-Hellman)

For more, check information on EAP-* methods.

##### Default mode
That mode consists of three two-way handshake:

1. Agree on algorithms and hash-function, used in IKE connection protection.
2. Shared secret key exchange by Diffie-Hellman algorithm. Peer identification by a random number request-response algorithm.
3. Secure connection is installed. Confirmation of Diffie-Hellman trusted channel.

The result is IKE SA installed on both peers.

##### Aggressive mode
This mode is also the same as Default, but more rapid:

1. Frist exchange contains all information of one peer (Step 1,2 in Default mode)
2. Second exchange contains all information from other peer (Step 1,2 in Default mode)
3. Confirmation (mandatory)

#### IKE Phase 2.
The second phase has only Quick mode. This phase use IPSec SA created by the first phase.

- Agree on the IPSec Policy between peers.
- Establish shared private keys for IPSec algorithms (AH, ESP)
- Install SA into kernel
