## About

This is a simple Ansible playbook to make your host be accessible by SNMP protocol. It utilizes SNMP v2 protocol, so there is no encryption suggestion by SNMP v3.

## Requirements

1. Installed ansible package  
For deb-based: `apt-get install ansible`
For prm-based: `yum install ansible`
2. A **[snmp]** group in */etc/ansible/hosts* file in your system. For extra details check this <a href="https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html">link</a>.

## Applicability
Currently, the playbook has been tested on:
- CentOS 7

## Usage

To run this code put into your terminal:  
`ansible-playbook install.yaml`.

Also, you can change some variables inside the main *install.yaml* playbook, but it's now mandatory.

After the playbook execution, you should be able to query a snmpd-powered host by typing:

`snmpwalk -c snmp -v2c <HOST>`

### Variables:
#### CentOS-specific
1. `allowed_zone` - A firewalld specified zone.   
You can choose any zone listed by `firewall-cmd --get-zones`. Make sure you have added an management interface to a specified zone by `firewall-cmd --add-interface=<INT> --zone=<ZONE>`


### Examples

1. On CentOS 7

`ansible-playbook install.yaml  --become --extra-vars "allowed_zone=private`
