# Install necessary packages
yum install epel-release
yum install strongswan
yum install haveged
yum install ipsec-tools

# Provide better randomness
systemctl enable haveged
systemctl start haveged

################################
### Starting configuring your CA
################################
# All actions must be done under this folder
cd /etc/strongswan

# Generate Private RSA key for CA
strongswan pki --gen --type rsa --size 4096 --outform der > ipsec.d/private/private_ca.der
chmod 600 ipsec.d/private/private_ca.der

# Generate Self-Signed Certificate for CA
strongswan pki --self --ca --lifetime 3650 --in ipsec.d/private/private_ca.der --type rsa --dn "C=RU, O=IT-Park, CN=Technical Dept Root CA" --outform der > ipsec.d/cacerts/ca_cert.der

# Show generated certificate
strongswan  pki --print --in ipsec.d/cacerts/ca_cert.der


# Generate private key for VPN IPSec server
strongswan pki --gen --type rsa --size 2048 --outform der > ipsec.d/private/vpnserver_priv_key.der
chmod 600 ipsec.d/private/vpnserver_priv_key.der


# Generate Certificate for VPN IPSec server to authenticate this side
# WARNING! You must put either your valid IP address or DNS name. Make sure you're already have a domain name which resolves in you VPN server or set
# local names in /etc/hosts or DNS server

strongswan pki --pub --in ipsec.d/private/vpnserver_priv_key.der --type rsa | strongswan pki --issue --lifetime 730 --cacert ipsec.d/cacerts/ca_cert.der --cakey ipsec.d/private/private_ca.der --dn "C=RU, O=IT-Park, CN=vpn.example.org" --san vpn.example.com --san vpn.example.net --san 172.17.116.59  --san @172.17.116.59 --flag serverAuth --flag ikeIntermediate --outform der > ipsec.d/certs/vpnserver_cert.der

# Show generated certificate
strongswan pki --print --in ipsec.d/certs/vpnHostCert.der


# Now we will generate client's PKI part
# First generate private key for user John

strongswan pki --gen --type rsa --size 2048 --outform der > ipsec.d/private/JohnKey.der
chmod 600 ipsec.d/private/JohnKey.der

# Generate and sign an user certificate with our CA private key and certificate. As both user's and server part was issued by the same CA, they can trust each other.
# CName should contain the same FQDN of the server, especially for Windows' client.
strongswan pki --pub --in ipsec.d/private/JohnKey.der --type rsa | strongswan pki --issue --lifetime 730 --cacert ipsec.d/cacerts/ca_cert.der --cakey ipsec.d/private/private_ca.der --dn "C=RU, O=IT Park Clients, CN=john@example.org" --san "john@example.org" --san "john@example.net" --outform der > ipsec.d/certs/JohnCert.der

# Then a little piece of magic to create a .p12 archive. It will contain both CA certificate, issued client certificate + user private key
openssl rsa -inform DER -in ipsec.d/private/JohnKey.der -out ipsec.d/private/JohnKey.pem -outform PEM
openssl x509 -inform DER -in ipsec.d/certs/JohnCert.der -out ipsec.d/certs/JohnCert.pem -outform PEM
openssl x509 -inform DER -in ipsec.d/cacerts/ca_cert.der -out ipsec.d/cacerts/ca_cert.pem -outform PEM

# Create a .p12 archive
openssl pkcs12 -export  -inkey ipsec.d/private/JohnKey.pem -in ipsec.d/certs/JohnCert.pem -name "John's VPN Certificate"  -certfile ipsec.d/cacerts/ca_cert.pem -caname "IT Park Root CA" -out John.p12 -passout pass:

# Then the generated .p12 archive can be deployed on any client and used to instantinate the IPSec VPN connection


##########################
# Configure strongswan daemon
##########################

# At this point, you have to think about the authentication mode you will use.
#
