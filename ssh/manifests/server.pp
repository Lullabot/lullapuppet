class ssh::server (
    $port   = 22,
    $permitrootlogin = 'no',
    $rsaauthentication = 'yes',
    $pubkeyauthentication = 'yes',
    $authorizedkeysfile = '%h/.ssh/authorized_keys',
    $passwordauthentication = 'no',
    $usedns = 'no',
    $denygroups = '',
    $gatewayports = 'no',
    ) {

    $ports = split($port, ' ')

    package { 'openssh-server':
        ensure  => present,
    }

    file { '/etc/ssh/sshd_config':
        content => template('ssh/etc/ssh/sshd_config.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Service['ssh'],
        require => Package['openssh-server'],
    }

    service { 'ssh':
        ensure  => running,
        enable  => true,
        require => Package['openssh-server'],
    }

}
