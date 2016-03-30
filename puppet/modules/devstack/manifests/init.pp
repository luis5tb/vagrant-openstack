class devstack ($controller = 'FALSE') {
    include devstack::clone
    if ($controller =~/TRUE/) {
        include devstack::controller
    } else {
        include devstack::worker
    }
}

class devstack::clone{
    git::clone {'https://git.openstack.org/openstack-dev/devstack':
        path => '/home/vagrant',
        dir => 'devstack',
        user => 'vagrant',
    }
}

class devstack::controller{
    file{'/home/vagrant/devstack/local.conf':
        ensure => present,
        owner => 'vagrant',
        group => 'vagrant',
        mode => 644,
        source => 'puppet:///modules/devstack/local.conf.Controller',
        require => [Class['devstack::clone']],
    }
}

class devstack::worker{
    file{'/home/vagrant/devstack/local.conf':
        ensure => present,
        owner => 'vagrant',
        group => 'vagrant',
        mode => 644,
        source => 'puppet:///modules/devstack/local.conf.Worker',
        require => [Class['devstack::clone']],
    }
}
