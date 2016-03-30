class nova ($worker = 'FALSE') {
    if ($worker =~/TRUE/) {
        include nova::worker
    } else {
        include nova::controller
    }
    include nova::service
}

class nova::controller{
    file { "/etc/nova/nova.conf":
        ensure => present,
        owner => 'vagrant',
        group => 'vagrant',
        mode => 644,
        source => "puppet:///modules/nova/nova.conf.Controller",
    }
}
class nova::worker{
    file { "/etc/nova/nova.conf":
        ensure => present,
        owner => 'vagrant',
        group => 'vagrant',
        mode => 644,
        source => "puppet:///modules/nova/nova.conf.Worker",
    }
}

class nova::service{
    file {'/home/vagrant/restart-n-cpu.sh':
        ensure => present,
        owner => 'vagrant',
        group => 'vagrant',
        mode => 744,
        source => "puppet:///modules/nova/restart-n-cpu.sh",
    }
    exec{'restart-n-cpu':
        command => "/usr/bin/bash /home/vagrant/restart-n-cpu.sh",
        user => 'vagrant',
        subscribe => File['/etc/nova/nova.conf'],
        require => File['/home/vagrant/restart-n-cpu.sh'],
    }
}
