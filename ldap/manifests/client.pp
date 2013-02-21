class ldap::client (
        $base,
        $uri,
        $ldap_version = 3,
        $binddn = undef,
        $bindpw = undef,
        $rootbinddn = undef,
        $rootbindpw = undef,
        $pam_password = 'md5',
        $nss_base_passwd = undef,
        $nss_base_shadow = undef,
        $nss_base_group = undef,
        $nss_map_attribute = undef,
        $nss_map_objectclass = undef,
        $ssl = 'off',
        $tls_checkpeer = 'yes',
        $tls_cacertfile = undef,
        $tls_cacertdir = undef,
        $sudoers_base = undef,
        ) {

    # Defaults
    File {
        owner   => 'root',
        group   => 'root',
        require => Package['libnss-ldap', 'libpam-ldap'],
    }

    # NSCD package name
    $nscd = $::lsbdistcodename ? {
        precise => 'unscd',
        default => 'nscd',
    }

    # Required packages
    package { ['libnss-ldap', 'libpam-ldap', $nscd, 'sudo-ldap']:
        ensure => present,
    }

    # NSCD service
    service { $nscd:
        ensure  => running,
        enable  => true,
        require => Package[$nscd],
    }

    # LDAP Configuration
    file { '/etc/ldap/ldap.conf':
        content => template('ldap/etc/ldap/ldap.conf.erb'),
    }

    # LDAP Authentication
    file { '/etc/ldap.conf':
        content => template('ldap/etc/ldap.conf.erb'),
    }

    if $rootbindpw {
        file { '/etc/ldap.secret':
            content => $rootbindpw,
            mode    => 0600,
        }
    }
    
    file { '/etc/nsswitch.conf':
        source => 'puppet:///modules/ldap/etc/nsswitch.conf',
    }

    file { '/etc/pam.d/common-password':
        source => 'puppet:///modules/ldap/etc/pam.d/common-password',
    }

    file { '/etc/pam.d/common-session':
        source => 'puppet:///modules/ldap/etc/pam.d/common-session',
    }

    file { '/etc/pam.d/common-session-noninteractive':
        source => 'puppet:///modules/ldap/etc/pam.d/common-session-noninteractive',
    }

}
