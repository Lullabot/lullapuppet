class puppet (
    $cron = true,
) {

    if !defined(Package['cronie']) {
        if $osfamily == 'RedHat' {
            if $operatingsystemrelease >= 6 {
                package { 'cronie':
                    ensure  => present,
                    notify  => Cron['puppet'],
                }
            }
        }

        if $operatingsystem == 'Amazon' {
            package { 'cronie':
                ensure  => present,
                notify  => Cron['puppet'],
            }
        }
    }

    file { '/etc/puppet/puppet.conf':
        ensure  => present,
        source  => 'puppet:///modules/puppet/etc/puppet/puppet.conf',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    cron { 'puppet':
        ensure  => $cron ? {
            true  => 'present',
            false => 'absent',
        },
        command => '/usr/bin/puppet agent --onetime --no-daemonize --logdest syslog > /dev/null 2>&1',
        user    => 'root',
        minute  => fqdn_rand( 60 ),
        require => File['/etc/puppet/puppet.conf'],
    }

    service { 'puppet':
        ensure  => stopped,
        enable  => false,
        require => Cron['puppet'],
    }

}
