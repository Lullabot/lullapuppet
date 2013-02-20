class zabbix::agent (
    $server         = 'zabbix',
    $serveractive   = 'zabbix',
    $port           = 10050,
    $startagents    = 3,
    ) {

    # File Defaults
    File {
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    package { 'zabbix-agent':
        ensure  => latest,
    }

    file { '/etc/zabbix/zabbix_agentd.conf':
        ensure  => present,
        content => template('zabbix/etc/zabbix/zabbix_agentd.conf.erb'),
        require => Package['zabbix-agent'],
        notify  => Service['zabbix-agent'],
    }

    file { '/etc/zabbix/zabbix_agentd.d':
        ensure  => absent,
        recurse => true,
        force   => true,
    }

    service { 'zabbix-agent':
        ensure  => running,
        enable  => true,
        require => Package['zabbix-agent'],
    }

}
