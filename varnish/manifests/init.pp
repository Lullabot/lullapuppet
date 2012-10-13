class varnish (
        $start          = 'yes',
        $http_port      = '80',
        $varnishncsa    = true,
        $varnishlog     = false,
        ) {

    File {
        require => Package['varnish'],
    }

    package { 'varnish':
        ensure  => present,
    }

    file { '/etc/default/varnish':
        content => template('varnish/etc/default/varnish.erb'),
        notify  => Service['varnish'],
    }

    file { '/etc/default/varnishlog':
        content => template('varnish/etc/default/varnishlog.erb'),
        notify  => Service['varnishlog'],
    }

    file { '/etc/default/varnishncsa':
        content => template('varnish/etc/default/varnishncsa.erb'),
        notify  => Service['varnishncsa'],
    }

    service { 'varnish':
        ensure  => running,
        enable  => true,
        require => File['/etc/default/varnish'],
    }

    service { 'varnishlog':
        ensure  => 'running',
        enable  => true,
        require => File['/etc/default/varnishlog'],
    }

    service { 'varnishncsa':
        ensure  => 'running',
        enable  => true,
        require => File['/etc/default/varnishncsa'],
    }

}
