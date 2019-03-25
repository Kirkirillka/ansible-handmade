# IPSec

## Information

A comprehensive look on how IPSec works you make take using this [a link](info/README.md)

## Testing

The server ansible role was tested on CentOS7 with strongswan installed against the following OS:

1. Windows - Compatible with IKEv2 by certificates, IKEv2-MSCHAPv2, IKEv2-PEAP (RADIUS required), IKEv2-RADIUES (RADIUS required)
2. Ubuntu - working with strongswan. All tests failed through default NetworkManager, may be there were some misconfiguration, though.
3. Fedora - working with openswan. The same for Ubuntu.


## Usage

Before usage you should make sure that you either use DNS with appropriate delegation or local records (via /etc/hosts). IPSec is highly recommended to be used with right DNS records.

After this, please, make sure you have `ansible` installed.

To run the playbook, put the group `[vpn]` into `/etc/hosts` and insert ip' of your future IPSec servers.

Finally, you can run the play by `ansible-playbook  --become install_server.yaml`.

After the play is finished, you will get `bundle.p12` PCKS12 package contains:

- Self-Signed ROOT CA Certificate.
- Private Key for the initial user (called John).
- Signed Certificate for John.

You should install the package on your OS. .p12 is easy to install on Windows and Android, for UNIX/MacOS information is available on the Internet.

Your IPSec serve will store CA , so you would be able to utilize PKI infrastructure to create extra users, but make sure you understand what are you doing.

**WARNING! DON'T REALLY STORE CA ALONG WITH IPSEC. IF IPSEC SERVER IS COMPROMISED, THE WHOLE SECURITY IS AT RISK.**


## Troubleshooting
Of course, in any difficult system, there are errors. In this section you may find information about [a type_here] (info) IPSecinstallation and configuration  in different OS's.
