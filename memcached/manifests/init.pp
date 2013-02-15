class memcached (
    $mem    = 64,
    $port   = 11211,
    $user   = 'nobody',
    $listen = '127.0.0.1'
    ) {

    package { 'memcached':
        ensure  => present,
    }

    service { 'memcached':
        ensure  => running,
        enable  => true,
        require => Package['memcached'],
    }

    file { '/etc/memcached.conf':
        ensure  => present,
        content => template('memcached/etc/memcached.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['memcached'],
        notify  => Service['memcached'],
    }

}
