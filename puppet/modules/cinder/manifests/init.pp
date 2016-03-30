class cinder {
    include cinder::config, cinder::service
}

class cinder::config{
    file { "/etc/cinder/cinder.conf":
        ensure => present,
        owner => 'vagrant',
        group => 'vagrant',
        mode => 644,
        source => "puppet:///modules/cinder/cinder.conf",
    }
}

class cinder::service{
    file {'/home/vagrant/restart-c-vol.sh':
        ensure => present,
        owner => 'vagrant',
        group => 'vagrant',
        mode => 744,
        source => "puppet:///modules/cinder/restart-c-vol.sh",
    }
    exec{'restart-c-vol':
        command => "/usr/bin/bash /home/vagrant/restart-c-vol.sh",
        user => 'vagrant',
        subscribe => File['/etc/cinder/cinder.conf'],
        require => File['/home/vagrant/restart-c-vol.sh'],
    }
}

