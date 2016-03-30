class iptables {
    include iptables::inconfig, iptables::outconfig
}

class iptables::inconfig {
    exec{'input-rule':
        command => "/usr/sbin/iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited",
    }
}

class iptables::outconfig {
    exec{'forward-rule':
        command => "/usr/sbin/iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited",
    }
}
