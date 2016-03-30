class libvirt{
    include libvirt::config, libvirt::service
}

class libvirt::config{
    file { "/etc/libvirt/libvirtd.conf":
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 644,
        source => "puppet:///modules/libvirt/libvirtd.conf",
        notify => Class['libvirt::service']
    }

    file { "/etc/sysconfig/libvirtd":
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 644,
        source => "puppet:///modules/libvirt/libvirtd",
        notify => Class['libvirt::service']
    }

}

class libvirt::service{
    service { "libvirtd":
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        enable => true,
    }
}


