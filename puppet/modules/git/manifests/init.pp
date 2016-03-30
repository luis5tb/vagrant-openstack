class git{
    include git::install
}

class git::install{
    package {'git':
        ensure => present
    }
}

define git::clone ( $path, $dir, $user){
    exec { "clone-$name-$user":
        command => "/usr/bin/git clone $name $path/$dir",
        creates => "$path/$dir",
        require => Class['git'],
        user => "$user",
    }
}
