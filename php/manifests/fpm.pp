class php::fpm (
        $pid        = '/var/run/php5-fpm.pid',
        $error_log  = '/var/log/php5-fpm.log',
        ) {

    File {
        ensure  => present,
        require => Package['php5-fpm'],
        notify  => Service['php5-fpm'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    apt::ppa { 'ppa:brianmercer/php5': }

    package { 'php5-fpm':
        ensure  => present,
        require => Apt::Ppa['ppa:brianmercer/php5'],
    }

#    file { '/etc/php5/fpm/php.ini':
#        content => template('php/etc/php/fpm/php.ini.erb'),
#    }

    file { '/etc/php5/fpm/php-fpm.conf':
        content => template('php/etc/php5/fpm/php-fpm.conf.erb'),
    }

    service { 'php5-fpm':
        ensure      => running,
        enable      => true,
        require     => Package['php5-fpm'],
        subscribe   => File['/etc/php5/conf.d/apc.ini'],
    }

    # Helper package for monitoring
    package { 'libfcgi0ldbl':
        ensure  => present,
    }

}
