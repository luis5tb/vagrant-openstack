class nets {
    include nets::cleanup, nets::create
}

class nets::cleanup {
    file{'/home/vagrant/cleanup_networks.sh':
        ensure => present,
        owner => 'vagrant',
        group => 'vagrant',
        mode => 744,
        source => 'puppet:///modules/nets/cleanup_networks.sh',
    }

    exec{'nets-cleanup':
        command => "/usr/bin/bash /home/vagrant/cleanup_networks.sh",
        require => File['/home/vagrant/cleanup_networks.sh'],
    }
}

class nets::create {
    file{'/home/vagrant/create_networks.sh':
        ensure => present,
        owner => 'vagrant',
        group => 'vagrant',
        mode => 744,
        source => 'puppet:///modules/nets/create_networks.sh',
    }

    exec{'nets-create':
        command => "/usr/bin/bash /home/vagrant/create_networks.sh",
        require => [Class['nets::cleanup'], File['/home/vagrant/create_networks.sh']],
    }
}
