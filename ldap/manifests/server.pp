class ldap::server {

    package { 'slapd':
        ensure => present,
    }

    service { 'slapd':
        ensure  => running,
        enable  => true,
        require => Package['slapd'],
    }

}
