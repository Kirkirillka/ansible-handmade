# Full IPSec installation Ansible Role

## Requirements

### Operation systems
The role was tested on:
- CentOS 7

It may be even possible to run the role on the other distributives, but you would have to adopt file path in the role's variables files.


## Abstract

The role is intended to run against Linux-based machines, to install credentials on MacOS/Windows/Android see [link](https://www.strongswan.org/docs/dfn_berlin_2011.pdf). `Strongswan` is intended to use as IKE keyring daemon. It will establish a policy-based VPN connection (difference between interface-based and policy-based VPN see [here](http://www.internet-computer-security.com/VPN-Guide/Policy-based-vs-Route-based-VPN.html) or [here](https://www.juniper.net/documentation/en_US/release-independent/nce/topics/concept/policy-based-route-based-vpn-comparing.html)).

This role will create a Certificate Authority center (CA), a running IPSec linux server, install packages on clients' machines, automatically deploy all necessary certificates and up connections.

By default, IKEv2-TLS with certificates is used, you may change the behavior by choosing a specific EAP-* method (see [this](https://wiki.strongswan.org/projects/strongswan/wiki/IKEv2Examples) link) and manually change the configuration files.

For Ansible role you must either change hosts' names in the playbooks or make sure you have configured specified host groups in your inventory (e.g. `/etc/ansible/hosts`):

- `[ca]` - should contains a one record to point the address of CA. There will be stored all PKI information. The host with CA role can be also used for `[ipsec]`, but this could leak to security issues.
- `[ipsec]` - a main server where all clients will connect to. Also is supposed to be a single role.
- `[clients]` - a list of linux machines where the role will automatically install and configure the connection. That can be useful if you'd like to secure your server infrastructure. All credentials will be automatically deployed, for this purpose check you configured user-cred mapping properly in `IPSEC_USER_MAPPING` variable.

After you have configured your inventory, then tailor the configuration files.

### Configuration files
If you want to adapt the default settings then it's free for you to change the following files:

- `config/vars.yaml` - used for common settings, to share the main options between different roles.
- `config/ca.yaml` - contains information for local Certificate Authority used to apply PKI's power.
- `config/server.yaml` - contains information for IPSec server installation. Highly recommended to change for the specific case.
- `config/users.yaml` -  contains information for customer's PKI credentials. You can add any amount of users, credentials for all of them would be automatically generated and stored on your host machine.


For the right working VPN network, the obligatory settings are:
- `IPSEC_IP` - the external IP address of VPN server;
- `IPSEC_USERS` - the list of users;
- `IPSEC_USER_MAPPING` - the mapping between users' credentials and automatically configured hosts.


## Usage

If you have done properly, then it's easy to run the playbook by typing:
`ansible-playbook main.yaml`.

Your user should be able to execute command under **root**. If your ansible user is in *wheel* \ *sudo* group, then just a slight modification is enough:
`ansible-playbook main.yaml --become`
