class asterisk {

    if $::osfamily == RedHat {

        # Prerequisite packages
        if !defined(Package['dnsmasq']) { package { 'dnsmasq': } }
        if !defined(Package['yum-utils']) { package { 'yum-utils': } }

        # Install the asterisk & digium repositories
        exec { 'asterisknow-version':
            command => 'rpm -i http://packages.asterisk.org/centos/6/current/i386/RPMS/asterisknow-version-3.0.0-1_centos6.noarch.rpm',
            creates => '/etc/asterisknow-version',
            require => Package['dnsmasq'],
        }

        # Enable the asterisk-11 repo
        exec { 'enable asterisk-11':
            command => 'yum-config-manager --enable asterisk-11',
            unless  => 'grep enabled=1 /etc/yum.repos.d/centos-asterisk-11.repo',
            require => [Package['yum-utils'], Exec['asterisknow-version']],
        }

        # Install asterisk
        package { ['asterisk', 'asterisk-configs']:
            require => Exec['enable asterisk-11'],
        }

    }


    if $::osfamily == Debian {
        package { 'linux-headers-server':
            ensure => present,
        }

        package { ['asterisk', 'dahdi-dkms', 'dahdi']:
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
