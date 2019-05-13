#!/bin/sh

USER="username"
VCD="vcd"
ORG="org"
VCLOUD="vc@dc.ru"

# 1. Login
vcd login -i $VCLOUD $ORG $NAME -v $VCD

# Change to vDC
vcd  vdc use $VCD

# Create a vApp
vcd vapp create DC_DDOS_Mitigation
# Attach public network to vApp
#vcd vapp connect  DC_DDOS_Mitigation PUBLIC

# Create vApp Network
vcd vapp network create  DC_DDOS_Mitigation LocalNet --subnet 192.168.0.254/24  --dns1 8.8.8.8 --dns2 8.8.8.9 --ip-range 192.168.0.1-192.168.0.20

# Create virtual machines
machine_names=(\
  DC_DDOS_Attacker\
  DC_DDOS_ELK_Suricata\
  DC_DDOS_OVS
)

for name in ${machine_names[*]}; do
     echo Creating a VM "$name"


     # Create a VM and assign to vApp
     vcd vapp add-vm DC_DDOS_Mitigation "CentOS7-[LocalNet][Inet_access]" CentOS7 -c IT-catalog -t "$name"

     # Update characteristics
     vcd vm update DC_DDOS_Mitigation "$name" --cpu 2 --cores 2 --memory 2096

     # Append a NIC to VM
     #vcd vm add-nic DC_DDOS_Mitigation  "$name" --network LocalNet --adapter-type VMXNET3 --connect  --ip-address-mode POOL
done


# Stop all working VM
vcd vapp stop DC_DDOS_Mitigation;

 # Create a VM for ELK, because it will require a lot of resources echo Creating a VM DC_DDOS_ELK_Suricata;
vcd vapp add-vm DC_DDOS_Mitigation "CentOS7-[LocalNet][Inet_access]" CentOS7 -c IT-catalog -t "DC_DDOS_ELK_Suricata";
vcd vm update DC_DDOS_Mitigation DC_DDOS_ELK_Suricata --cpu 6 --cores 1 --memory 12128;

# Start up
 vApp vcd vapp power-on DC_DDOS_Mitigation;
