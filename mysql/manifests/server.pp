class mysql::server {

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

}
