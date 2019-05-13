# https://www.linuxtechi.com/install-use-openvswitch-kvm-centos-7-rhel-7/


###
# About script
###

# This script will automatically install OpenVSwitch 2.9.2. (instruction taken from https://www.linuxtechi.com/install-use-openvswitch-kvm-centos-7-rhel-7/). It may be not the latest version, but it was proved that the following features worked well on CentOS7:
# - Simple bridging several interfaces
# - Netflow collection
# - SPAN mirroring
# - ERSPAN mirroring

# Install packages
yum install wget openssl-devel  python-sphinx gcc make python-devel openssl-devel kernel-devel graphviz kernel-debug-devel autoconf automake rpm-build redhat-rpm-config libtool python-twisted-core python-zope-interface PyQt4 desktop-file-utils libcap-ng-devel groff checkpolicy selinux-policy-devel -y

# Create user to run the command under
useradd ovs
su - ovs

# Download and extract sources
mkdir -p ~/rpmbuild/SOURCES
wget http://openvswitch.org/releases/openvswitch-2.9.2.tar.gz
cp openvswitch-2.9.2.tar.gz ~/rpmbuild/SOURCES/
tar xfz openvswitch-2.9.2.tar.gz
rpmbuild -bb --nocheck openvswitch-2.9.2/rhel/openvswitch-fedora.spec
exit

# Install from RPM package
yum localinstall /home/ovs/rpmbuild/RPMS/x86_64/openvswitch-2.9.2-1.el7.x86_64.rpm -y

# Run service
systemctl start openvswitch.service
systemctl enable openvswitch.service

# Create first bridge
ovs-vsctl add-br ovsbridge0

# At this step, you may add as many host interfaces as you want
# The bridge ovsbridge0 seems as another interface in your machine, so you can use NetworkManager to automatically boot it and set up (via /etc/sysconfig/network-scripts/ifcfg-ovs-vr0). It was tested against DHCP server to sucessfully lease an IP address and to be able to communicate over network.
