class vagrant::ssh ( $source = '/vhome') {

    file { "$source/.ssh":
        ensure => directory,
    }

    file { '/home/vagrant/.ssh':
        ensure  => directory,
        owner   => vagrant,
        group   => vagrant,
        source  => "$source/.ssh",
        recurse => true,
        require => File["$source/.ssh"],
    }

}
