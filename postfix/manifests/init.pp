class postfix (
        $mailname       = $::fqdn,
        $myhostname     = $::fqdn,
        $mydestination  = "$::fqdn, localhost",
        $canonical_maps = undef,
    ) {

    File {
        ensure  => present,
        require => Package['postfix'],
        notify  => Service['postfix'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    package { 'postfix':
        ensure  => present,
    }

    service { 'postfix':
        ensure  => running,
        enable  => true,
        require => Package['postfix'],
    }

    file { '/etc/postfix/main.cf':
        content => template('postfix/etc/postfix/main.cf.erb'),
    }

    file { '/etc/mailname':
        content => "$mailname\n",
    }
}
