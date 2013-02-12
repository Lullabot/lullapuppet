class mysql::server (
        $backup             = true,
        $backup_retention   = 30,
        $backup_hour        = 2,
        $backup_s3_bucket   = false,
        ) { 

    include mysql::client

    package { ['mysql-server']:
        ensure  => present,
    }

    service { 'mysql':
        ensure  => running,
        enable  => true,
        require => Package['mysql-server'],
    }

    file { '/etc/mysql/my.cnf':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    file { '/usr/local/bin/mysqltuner.pl':
        ensure  => present,
        source  => 'puppet:///modules/mysql/usr/local/bin/mysqltuner.pl',
        mode    => '0755',
    }

    file { '/usr/local/bin/mysqlbackup':
        ensure  => present,
        source  => 'puppet:///modules/mysql/usr/local/bin/mysqlbackup',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    cron { 'mysqlbackup':
        ensure  => $backup ? {
            true    => 'present',
            default => 'absent',
        },
        user    => 'root',
        command => $backup_s3_bucket ? {
            false   => "/usr/local/bin/mysqlbackup -r ${backup_retention}",
            default => "/usr/local/bin/mysqlbackup -r ${backup_retention} -s ${backup_s3_bucket}",
        },
        hour    => $backup_hour,
        minute  => 0,
    }

}
