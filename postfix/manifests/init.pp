class postfix {

    package { 'postfix':
        ensure  => present,
    }

    service { 'postfix':
        ensure  => running,
        enable  => true,
        require => Package['postfix'],
    }

}
