USER="username"
VCD="vcd"
ORG="org"
VCLOUD="vc@dc.ru"

# 1. Login
vcd login -i $VCLOUD $ORG $NAME -v $VCD

# 2. Create empty vApp
vcd vapp  create  DC-Installation-from-CLI

# 3. Create vApp Local network
vcd vapp network create  DC-Installation-from-CLI LocalNet --subnet 192.168.0.254/24  --dns1 8.8.8.8 --dns2 8.8.8.9 --ip-range 192.168.0.1-192.168.0.20
# Then you should go to Web panel and set "Connection" option to be linked to a network from where you have access to the Internet (for example, LAN, in my case)

# 4. Create a VM from catalog and attach it to vApp
vcd vapp add-vm -c IT-catalog -t "DC-CentOS7-1"  -o centos7-1 -n LocalNet -i pool  "DC-Installation-from-CLI"  "CentOS7-[LocalNet][Inet_access]"  "CentOS7"

# 5. Optional. You can add new NIC to VM if your template doesn't include some.
# vcd vm add-nic --network LocalNet --connect --ip-address-mode POOL  --adapter-type VMXNET3  DC-Installation-from-CLI DC-CentOS7-1
