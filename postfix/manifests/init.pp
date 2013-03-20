class postfix (
        $myhostname     = $::fqdn,
        $canonical_maps = undef,
    ) {

    package { 'postfix':
        ensure  => present,
    }

    service { 'postfix':
        ensure  => running,
        enable  => true,
        require => Package['postfix'],
    }

    file { '/etc/postfix/main.cf':
        ensure  => present,
        content => template('postfix/etc/postfix/main.cf.erb'),
        notify  => Service['postfix'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

}
