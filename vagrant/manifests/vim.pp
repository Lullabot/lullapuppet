class vagrant::vim ( $source = '/vhome') {

    if !defined(Package['vim']) { package { 'vim': } }

    file { "$source/.vimrc":
        ensure => present,
    }

    file { '/home/vagrant/.vimrc':
        ensure  => present,
        source  => "$source/.vimrc",
        owner   => vagrant,
        group   => vagrant,
        require => File["$source/.vimrc"],
    }

    file { "$source/.vim":
        ensure => directory,
    }

    file { '/home/vagrant/.vim':
        ensure  => directory,
        source  => "$source/.vim",
        owner   => vagrant,
        group   => vagrant,
        recurse => true,
        require => File["$source/.vim"],
    }

}
