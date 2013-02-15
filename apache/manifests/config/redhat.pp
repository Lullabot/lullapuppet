class apache::config::redhat (
        $http_user = 'apache',
        $http_group = 'apache',
        $http_port,
        $https_port,
        $mod_auth_token,
        $mod_authnz_ldap,
        $mod_h264_streaming,
        $mod_headers,
        $mod_passenger,
        $mod_php5,
        $mod_proxy,
        $mod_rewrite,
        $mod_ssl,
        $mod_status,
        ) {

    # Class defaults
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache'],
        notify  => Service['apache'],
    }

    # Global config
    file { '/etc/httpd/conf/httpd.conf':
        content => template('apache/etc/httpd/conf/httpd.conf.erb'),
    }

    # mod_passenger
    if $mod_passenger {
        warning('mod_passenger is not supported for this operating system.')
    }

    # mod_ssl
    package { 'mod_ssl':
        ensure  => $mod_ssl ? {
            false   => 'absent',
            default => 'present',
        }
    }

}
