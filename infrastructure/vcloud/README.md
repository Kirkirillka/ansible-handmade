## What is vCloud Director

First of all, vCloud is an orchestrator. It integrates with existing VMware vSphere  deployments. vCloud help utilize IaaS approach as well as self-managed service approach.


## Terminology
- Organization - a tenant, which can own one or several Virtual Datacenters
- Virtual Datacenter(VC) - an abstraction stands for environment where virtual machines are running. It can be thought as a virtual representation of a real datacenter
- Catalog - a set of defined files (Tempaltes, Media files) which can be used while building infrastructure
- Virtual Machine - as a classifcan definition, it's a server instance where hardware seen by the server operating system is abstracted from the physical hardware by a hypervisor
- vApp - is a group of VMs that work together to perform a function.


## Components
- vShield
- vCenter Server
- vCloud Director


## Networks

### Types of Networks
- Isolated - fully independent networks. No routing, no leakage. Suitable for VM, which doesn't require external communication
- Routed Org vDC - can send and receive external traffic, use NAT, Firewalls and VPNs.

## Links
- http://www.davidhill.co/2012/02/vmware-vcloud-director-101-overview-part-1/
- https://habr.com/ru/company/dataline/blog/256733/
