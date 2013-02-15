class apache::config::debian (
        $http_user = 'www-data',
        $http_group = 'www-data',
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

    # Sites available/enabled directories
    file { ['/etc/apache2/sites-available', '/etc/apache2/sites-enabled']:
        ensure  => directory,
    }

    # Global config
    # @todo - Fix this for 12.04
#    file { '/etc/apache2/envvars':
#        content => template('apache/etc/apache2/envvars.erb'),
#    }

    file { '/etc/apache2/ports.conf':
        content => template('apache/etc/apache2/ports.conf.erb'),
    }

    file { '/etc/apache2/conf.d/logformat':
        source  => 'puppet:///modules/apache/etc/apache2/conf.d/logformat',
    }


    # Disable default site
    file { '/etc/apache2/sites-enabled/000-default':
        ensure  => absent,
    }

    # mod_auth_token
    if $mod_auth_token {
        warning('mod_auth_token is not supported for this operating system.')
    }

    # mod_authnz_ldap
    file { '/etc/apache2/mods-enabled/authnz_ldap.load':
        ensure => $mod_authnz_ldap ? {
            true    => '/etc/apache2/mods-available/authnz_ldap.load',
            default => 'absent',
        },
    }
    file { '/etc/apache2/mods-enabled/ldap.load':
        ensure => $mod_authnz_ldap ? {
            true    => '/etc/apache2/mods-available/ldap.load',
            default => 'absent',
        },
    }
    file { '/etc/apache2/mods-enabled/ldap.conf':
        ensure => $mod_authnz_ldap ? {
            true    => 'present',
            default => 'absent',
        },
        content => 'LDAPTrustedGlobalCert CA_DER /etc/ssl/certs/ca-certificates.crt',
    }

    # mod_h264_streaming
    if $mod_h264_streaming {
        warning('mod_h264_streaming is not supported for this operating system.')
    }

    # mod_headers
    file { '/etc/apache2/mods-enabled/headers.load':
        ensure  => $mod_headers ? {
            true    => '/etc/apache2/mods-available/headers.load',
            default => 'absent',
        },
    }

    # mod_passenger
    if $mod_passenger {
        package { ['libapache2-mod-passenger', 'rails', 'librack-ruby', 'libmysql-ruby']:
            ensure  => present,
            notify  => Service['apache2'],
        }
    }
    file { '/etc/apache2/mods-enabled/passenger.conf':
        ensure  => $mod_passenger ? {
            true    => '/etc/apache2/mods-available/passenger.conf',
            default => 'absent',
        },
    }
    file { '/etc/apache2/mods-enabled/passenger.load':
        ensure  => $mod_passenger ? {
            true    => '/etc/apache2/mods-available/passenger.load',
            default => 'absent',
        },
    }

    # mod_php5
    if $mod_php5 {
        package { 'libapache2-mod-php5':
            ensure  => present,
            notify  => Service['apache2'],
        }
    }
    file { '/etc/apache2/mods-enabled/php5.conf':
        ensure  => $mod_php5 ? {
            true    => '/etc/apache2/mods-available/php5.conf',
            default => 'absent',
        },
    }
    file { '/etc/apache2/mods-enabled/php5.load':
        ensure  => $mod_php5 ? {
            true    => '/etc/apache2/mods-available/php5.load',
            default => 'absent',
        },
    }

    # mod_proxy
    file { '/etc/apache2/mods-enabled/proxy.conf':
        ensure  => $mod_proxy ? {
            true    => '/etc/apache2/mods-available/proxy.conf',
            default => 'absent',
        },
    }
    file { '/etc/apache2/mods-enabled/proxy_http.load':
        ensure  => $mod_proxy ? {
            true    => '/etc/apache2/mods-available/proxy_http.load',
            default => 'absent',
        },
    }
    file { '/etc/apache2/mods-enabled/proxy.load':
        ensure  => $mod_proxy ? {
            true    => '/etc/apache2/mods-available/proxy.load',
            default => 'absent',
        },
    }

    # mod_rewrite
    file { '/etc/apache2/mods-enabled/rewrite.load':
        ensure  => $mod_rewrite ? {
            true    => '/etc/apache2/mods-available/rewrite.load',
            default => 'absent',
        },
    }

    # mod_ssl
    file { '/etc/apache2/mods-enabled/ssl.conf':
        ensure  => $mod_ssl ? {
            true    => '/etc/apache2/mods-available/ssl.conf',
            default => 'absent',
        },
    }
    file { '/etc/apache2/mods-enabled/ssl.load':
        ensure  => $mod_ssl ? {
            true    => '/etc/apache2/mods-available/ssl.load',
            default => 'absent',
        },
    }

    # mod_status
    file { '/etc/apache2/mods-enabled/status.load':
        ensure  => $mod_status ? {
            true    => '/etc/apache2/mods-available/status.load',
            default => 'absent',
        },
    }
    file { '/etc/apache2/conf.d/server-status':
        ensure  => $mod_status ? {
            true    => 'present',
            default => 'absent',
        },
        source  => 'puppet:///modules/apache/etc/apache2/conf.d/server-status',
    }

    # Log rotation
    file { '/etc/logrotate.d/apache2':
        ensure => present,
        source => 'puppet:///modules/apache/etc/logrotate.d/apache2',
    }
}
