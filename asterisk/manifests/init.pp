class asterisk {

    if $::osfamily == RedHat {

        # Prerequisite packages
        if !defined(Package['dnsmasq']) { package { 'dnsmasq': } }

        # Install the asterisk & digium repositories
        package { 'asterisknow-version':
            require  => Package['dnsmasq'],
            provider => rpm,
            source   => "http://packages.asterisk.org/centos/6/current/${::architecture}/RPMS/asterisknow-version-3.0.0-1_centos6.noarch.rpm",
            ensure   => installed,
        }

        # Enable the asterisk-11 repo
        yumrepo { 'asterisk-11':
            require => Package['asterisknow-version'],
            enabled => 1,
        }

        # Install asterisk
        package { ['asterisk', 'asterisk-configs']:
            require => Yumrepo['asterisk-11'],
        }

    }


    if $::osfamily == Debian {
        package { 'linux-headers-server':
            ensure => present,
        }

        package { ['asterisk', 'asterisk-dahdi', 'dahdi-dkms', 'dahdi']:
            ensure  => present,
            require => Package['linux-headers-server'],
        }

        service { 'dahdi':
            ensure  => running,
            enable  => true,
            require => Package['dahdi'],
        }

        service { 'asterisk':
            ensure  => running,
            enable  => true,
            require => [Package['asterisk'], Service['dahdi']],
        }
    }
}
