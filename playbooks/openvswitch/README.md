
# Install OpenVSwitch on CentOS, create a OVS switch, add two physical adapters, create a DHCP-powered interface in the OVS switch

<code bash>
/bin/sh scripts/install_openvswitch.sh
ovs-vsctl add-port ovsbridge0 eth0   
ovs-vsctl add-port ovsbridge0 eth1   
systemctl restart network
</code>

# Create a OVS switch, add ports, send Netflow statistics to a remote host

<code bash>
ovs-vsctl add-br ovsbridge0
ovs-vsctl add-port ovsbridge0 eth0  
ovs-vsctl add-port ovsbridge0 eth1  
ovs-vsctl set Bridge ovsbridge0 netflow=@nf0 \
      -- --id=@nf0 create NetFlow targets=\"192.168.89.2016:2055\" \
      add_id_to_interface=true
</code>

# Create a OVS switch, add ports, mirror all traffic to one port

<code bash>
ovs-vsctl add-br ovsbridge0  
ovs-vsctl add-port ovsbridge0 eth0  
ovs-vsctl add-port ovsbridge0 eth1 -- --id=@p get port eth1 -- --id=@m create mirror name=m0 selectl-all=true output-port=@p  -- set bridge ovsbridge0 mirrors=@m
</code>


# Create a OVS switch, install GRE tunnel, use this to mirror all traffic to a remote host

<code bash>
ovs-vsctl add-br ovsbridge0  
ovs-vsctl add-port ovsbridge0 eth0  
ovs-vsctl add-port ovsbridge0 eth1  
ovs-vsctl add-port ovsbridge0 gre0 \
     -- set interface gre0 type=gre options:remote_ip=192.168.89.216 \
     -- --id=@p get port gre0 \
     -- --id=@m create mirror name=m0 select-all=true output-port=@p \
     -- set bridge ovsbridge0 mirrors=@m

</code>
