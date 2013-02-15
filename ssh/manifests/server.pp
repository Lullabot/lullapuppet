class ssh::server (
    $port   = 22,
    $permitrootlogin = 'no',
    $rsaauthentication = 'yes',
    $pubkeyauthentication = 'yes',
    $authorizedkeysfile = '%h/.ssh/authorized_keys',
    $authorizedkeysfile2 = '%h/.ssh/authorized_keys2',
    $passwordauthentication = 'no',
    $usedns = 'no',
    $denygroups = '',
    $gatewayports = 'no',
    ) {

    $ports = split($port, ' ')

    package { 'openssh-server':
        ensure  => present,
    }

    $service = $osfamily ? {
        redhat  => 'sshd',
        default => 'ssh',
    }

    file { '/etc/ssh/sshd_config':
        content => template('ssh/etc/ssh/sshd_config.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Service[$service],
        require => Package['openssh-server'],
    }

    service { $service:
        ensure  => running,
        enable  => true,
        require => Package['openssh-server'],
    }

}
