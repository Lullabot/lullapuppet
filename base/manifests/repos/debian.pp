class base::repos::debian {
    
    $dist = downcase($lsbdistid)

    # Apt Configuration
    file { '/etc/apt/apt.conf.d/10periodic':
        ensure  => present,
        source  => 'puppet:///modules/base/debian/etc/apt/apt.conf.d/10periodic',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

}
