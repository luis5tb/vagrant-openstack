cd /home/vagrant/devstack/

. openrc admin admin

neutron router-gateway-clear router1

neutron net-delete public

neutron router-interface-delete router1 private-subnet    
neutron subnet-delete private-subnet

neutron router-interface-delete router1 ipv6-private-subnet    
neutron subnet-delete ipv6-private-subnet

neutron net-delete private

neutron router-delete router1

#neutron security-group-list | grep default | awk '{print "neutron security-group-delete "$2}' | sh

