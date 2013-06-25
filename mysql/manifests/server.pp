class mysql::server (
        $max_allowed_packet             = '64M',
        $skip_name_resolve              = true,
        $max_connections                = 100,
        $table_open_cache               = 400,
        $default_storage_engine         = 'innodb',
        $innodb_flush_method            = 'O_DIRECT',
        $innodb_flush_log_at_trx_commit = 2,
        $innodb_log_buffer_size         = '8M',
        $innodb_log_file_size           = '256M',
        $innodb_file_per_table          = true,
        $innodb_buffer_pool_size        = undef,
    ) {

    include mysql::client

    package { 'mysql-server':
        ensure  => present,
    }

    service { 'mysql':
        ensure  => running,
        enable  => true,
        require => Package['mysql-server'],
    }

    file { '/usr/local/bin/mysqltuner.pl':
        ensure  => present,
        source  => 'puppet:///modules/mysql/usr/local/bin/mysqltuner.pl',
        mode    => '0755',
    }

    file { '/etc/mysql/my.cnf':
        ensure  => present,
        content => template('mysql/etc/mysql/my.cnf.erb'),
        require => Package['mysql-server'],
        notify  => Exec['rm -f /var/lib/mysql/ib_logfile*'],
    }

    exec { 'rm -f /var/lib/mysql/ib_logfile*':
        refreshonly => true,
        notify      => Service['mysql'],
    }

}
