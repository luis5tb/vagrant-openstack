class ovs ($server_ip = '192.168.5.2'){
    include ovs::bridge, ovs::port, ovs::nic
    class {'ovs::config' : server_ip => $server_ip}
}

class ovs::bridge {
    exec{'add-bridge':
        command => "/usr/bin/ovs-vsctl --may-exist add-br br-eth1",
    }
}

class ovs::port {
    exec{'add-port':
        command => "/usr/bin/ovs-vsctl --may-exist add-port br-eth1 eth1",
        require => [Class['ovs::bridge']],
    }
}

class ovs::nic {
    exec{'down-eth1':
        command => "/usr/sbin/ifconfig eth1 0",
        require => [Class['ovs::port']],
    }
}

class ovs::config ($server_ip = '192.168.5.2') {
    exec{'up-br-eth1':
        command => "/usr/sbin/ifconfig br-eth1 $server_ip/24 up",
        require => [Class['ovs::nic']],
    }
}
