class ferm (
    $input      = 'DROP',
    $output     = 'DROP',
    $forward    = 'DROP',
    $admin      = false,
    $icmp       = true,
    ) {

    # Defaults
    File {
        require => Package['ferm'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    package { 'ufw':
        ensure  => purged,
    }

    package { ['iptables', 'ferm']:
        ensure  => present,
    }

    service { 'ferm':
        enable      => true,
        require     => Package['ferm'],
    }

    if ($admin) {
        ferm::rule { '00-admin':
           dport => $admin,
        }
    }

    # Ensure ferm rules are refreshed after the main stage
    stage { ferm: require => Stage[main] }
    class { 'ferm::enforce': stage => ferm }

    # Config Files
    file { '/etc/ferm/ferm.conf':
        ensure  => present,
        content => template('ferm/etc/ferm/ferm.conf.erb'),
    }

    file { '/etc/ferm/ossec.exempt.d':
        ensure => directory,
        recurse => true,
        purge   => true,
    }

    file { '/etc/ferm/ossec.ferm':
        ensure  => present,
    }

    file { '/etc/ferm/ferm.d':
        ensure  => directory,
        recurse => true,
        purge   => true,
    }

    file { '/etc/ferm/ferm.d/README':
        ensure  => present,
        content => "# This directory is managed by puppet. Anything added here manually will be deleted\n",
        require => File['/etc/ferm/ferm.d'],
    }

}
