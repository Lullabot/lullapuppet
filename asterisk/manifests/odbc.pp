class asterisk::odbc {
    if !defined(Package['unixodbc']) { package { 'unixodbc': } }
    if !defined(Package['unixodbc-dev']) { package { 'unixodbc-dev': } }
    if !defined(Package['libmyodbc']) { package { 'libmyodbc': } }

    $arch = $::architecture ? {
        'amd64' => 'x86_64',
        default => 'i386',
    }

    file { '/etc/odbcinst.ini':
        content => template('asterisk/odbcinst.ini.erb'),
        owner   => 'root',
        group   => 'root',
        require => Package['unixodbc'],
        before  => Service['asterisk'],
    }

    file { '/etc/odbc.ini':
        source  => 'puppet:///modules/asterisk/odbc.ini',
        owner   => 'root',
        group   => 'root',
        require => Package['unixodbc'],
        before  => Service['asterisk'],
    }
}
