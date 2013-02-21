class ldap::server (
        $backup             = true,
        $backup_retention   = 30,
        $backup_hour        = 2,
        $backup_s3_bucket   = false,
        ) {
    
    package { 'slapd':
        ensure => present,
    }

    service { 'slapd':
        ensure  => running,
        enable  => true,
        require => Package['slapd'],
    }

    file { '/usr/local/bin/ldapbackup':
        ensure => present,
        source => 'puppet:///modules/ldap/usr/local/bin/ldapbackup',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    cron { 'ldapbackup':
        ensure  => $backup ? {
            true    => 'present',
            default => 'absent',
        },
        user    => 'root',
        command => "/usr/local/bin/ldapbackup -r ${backup_retention}",
        hour    => $backup_hour,
        minute  => 0,
    }

    cron { 'ldapbackup-s3':
        ensure => $backup_s3_bucket ? {
            false   => 'absent',
            default => 'present',
        },
        user    => 'root',
        command => "/usr/local/bin/ldapbackup -r ${backup_retention} -s ${backup_s3_bucket}",
        hour    => 4,
        minute  => 0,
        weekday => 0,
    }

}
