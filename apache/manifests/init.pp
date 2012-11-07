class apache (
        $ensure         = 'running',
        $enable         = true,
        $http_port      = 80,
        $https_port     = 443,
        $mod_headers    = false,
        $mod_passenger  = false,
        $mod_php5       = false,
        $mod_proxy      = false,
        $mod_rewrite    = true,
        $mod_ssl        = true,
        $mod_status     = true,
        ) {

    # Class defaults
    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apache2'],
        notify  => Service['apache2'],
    }

    # Dependencies
    if !defined(Package['imagemagick']) { package { 'imagemagick': ensure => present } }

    # Apache Packages
    package { 'apache2':
        ensure  => present,
    }

    # Apache Service
    service { 'apache2':
        ensure  => $ensure,
        enable  => $enable,
        require => Package['apache2'],
    }

    # Sites available/enabled directories
    file { ['/etc/apache2/sites-available', '/etc/apache2/sites-enabled']:
        ensure  => directory,
    }

    # Global config
    file { '/etc/apache2/ports.conf':
        content => template('apache/etc/apache2/ports.conf.erb'),
    }

    # Disable default site
    file { '/etc/apache2/sites-enabled/000-default':
        ensure  => absent,
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
    file { '/etc/php5/apache2/php.ini':
        ensure  => $mod_php5 ? {
            true    => '/etc/php5/apache2/php.ini',
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

}
