cd /home/vagrant/devstack/

. openrc admin admin

neutron net-create external --router:external=True --provider:network_type vlan
neutron subnet-create --disable-dhcp external 172.24.5.0/24

nova flavor-create m1.nano auto 128 1 1

#. openrc demo demo

ssh-keygen -t rsa -b 2048 -N '' -f id_rsa_admin
nova keypair-add --pub-key id_rsa_admin.pub admin

neutron net-create net0 
#--provider:network_type vlan

neutron subnet-create --name net0-subnet0 --dns-nameserver 8.8.8.8 net0 10.0.1.0/24

neutron security-group-create allowSSH
neutron security-group-rule-create --protocol icmp allowSSH

neutron security-group-rule-create --protocol tcp --port-range-min 22 --port-range-max 22 allowSSH

neutron router-create extrouter
neutron router-gateway-set extrouter external
neutron router-interface-add extrouter net0-subnet0


#ovs-vsctl add-port br-ex eth2
#ifconfig eth2 0
#ifconfig br-ex 192.168.100.2/24 up

ip addr add 172.24.5.1/24 dev br-ex
