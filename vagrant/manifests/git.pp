class vagrant::git ($source = '/vhome') {

    if !defined(Package['git']) { package { 'git': } }

    file { "$source/.gitconfig":
        ensure => present,
    }

    file { '/home/vagrant/.gitconfig':
        ensure  => present,
        owner   => vagrant,
        group   => vagrant,
        source  => "$source/.gitconfig",
        require => File["$source/.gitconfig"],
    }

}
