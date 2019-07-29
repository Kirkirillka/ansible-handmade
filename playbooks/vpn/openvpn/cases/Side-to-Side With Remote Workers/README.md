# OpenVPN. Semi Side-to-Side VPN with Remote Workers

## Credits

Thanks to @kyl191 for one of the amazing Ansible role for OpenVPN server ([link](https://github.com/kyl191/ansible-role-openvpn)).

## Info

This project is to provide a VPN network using OpenVPN protocol, which connects two sides (remote networks).

Users can have VPN access to reach the advertised routes.

Here are two sides:

- **Left side**  (also called **internal gateway**) is supposed to be under NAT. This is a mere OpenVPN client, but with client-side routing enabled. The left side establishes connection to a *right side*, a real VPN server, that updates its route table if necessary.
- **Right side**  (also called **external gateway**) - a real VPN server. Must have a public IP address. The right side received VPN connections and route traffic to the LAN network behind the left side. It takes time a little to update routing table if a user starts trying to access routes behind the left side.


## Usage

### Parameters and feature tailoring

Basically, the most parameters are taken from the original Ansible [role](https://github.com/kyl191/ansible-role-openvpn), so, it would be wise to take a look there first.

Some new variables were introduced to make cliend-side routing possible. 

A little brief on depending variables, the soul of the role consist of:

| Variable | Default value| Meaning |  
| ---|---|---|
| `clients` | empty | A list of client configuration names. As example, there are 2 clients and one with client-side routing emapled|
| `openvpn_push` | empty | A list of routes which the server will push onto clients, force them to route traffic to the networks through the VPN server. Should contain also the networks behind clients with client-side routed LANs | 
| `openvpn_clients_lan`  | empty | A dictionary containing client names which a list of networks behind them. By modifying this variable, you can control, what networks the VPN server will think that they are behind a concrete client, so the traffic will be routed to that client. Clients should allow IP forwarding. |

### Testing\Development

Here is Vagrantfile to help you to start all necessary infrastructure in just one click.

To run your local environment, just type:

```bash
vagrant up
```

One think is you should manually transfer configuration files and deploy on your corresponding clients and the left side to make Side-to-Side routing.

### Production\External Environment

Make sure you have an inventory file. The playbooks don't take any specific Ansible host groups, it takes `all` by default.

`inventory.yml`:

```bash
31.13.13.130:2224
```

If you want to run OpenVPN outside your computer, you can simply execute the playbooks provided in `ansible/playbooks` directory.

```bash
ansible-playbook -i inventory.yml -u root ansible/playbooks/do_rightside.yml
```
