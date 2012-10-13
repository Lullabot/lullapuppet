class php (
        $apc        = true,
        $gd         = true,
        $imagick    = true,
        $mcrypt     = true,
        $mysql      = true,
        $mysqli     = true,
        $oauth      = false,
        $pdo        = true,
        $pdo_mysql  = true,
        $notify     = undef,
        ) {

    # Defaults
    File {
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['php5'],
        notify  => $notify,
    }

    Package {
        ensure  => present,
        require => Package['php5'],
    }

    # Packages
    if !defined(Package['php5'])            { package { 'php5': require => undef } }
    if !defined(Package['php5-curl'])       { package { 'php5-curl': } }
    if !defined(Package['php5-dev'])        { package { 'php5-dev': } }
    if !defined(Package['php5-gd'])         { package { 'php5-gd': } }
    if !defined(Package['php5-imagick'])    { package { 'php5-imagick': } }
    if !defined(Package['php5-mcrypt'])     { package { 'php5-mcrypt':  } }
    if !defined(Package['php5-memcache'])   { package { 'php5-memcache':  } }
    if !defined(Package['php5-memcached'])  { package { 'php5-memcached':  } }
    if !defined(Package['php5-mysql'])      { package { 'php5-mysql': } }
    if !defined(Package['php5-xmlrpc'])     { package { 'php5-xmlrpc': } }
    if !defined(Package['php5-xsl'])        { package { 'php5-xsl': } }
    if !defined(Package['php-apc'])         { package { 'php-apc': } }
    if !defined(Package['php-pear'])        { package { 'php-pear': } }

    # Files/Directories
    file { '/usr/local/share/php':
        ensure  => directory,
    }

    # APC
    file { '/etc/php5/conf.d/apc.ini':
        ensure  => present,
        content => $apc ? {
            true    => "extension=apc.so\n",
            default => ";extension=apc.so\n",
        },
    }

    file { '/usr/local/share/php/apc.php':
        ensure  => present,
        source  => 'puppet:///modules/php/usr/local/share/php/apc.php',
        require => File['/usr/local/share/php'],
        mode    => '0755',
    }

    # GD
    file { '/etc/php5/conf.d/gd.ini':
        ensure  => present,
        content => $gd ? {
            true    => "extension=gd.so\n",
            default => ";extension=gd.so\n",
        },
    }

    # Imagick
    file { '/etc/php5/conf.d/imagick.ini':
        ensure  => present,
        content => $imagick ? {
            true    => "extension=imagick.so\n",
            default => ";extension=imagick.so\n",
        },
    }

    # mcrypt
    file { '/etc/php5/conf.d/mcrypt.ini':
        ensure  => present,
        content => $mcrypt ? {
            true    => "extension=mcrypt.so\n",
            default => ";extension=mcrypt.so\n",
        },
    }

    # MySQL
    file { '/etc/php5/conf.d/mysql.ini':
        ensure  => present,
        content => $mysql ? {
            true    => "extension=mysql.so\n",
            default => ";extension=mysql.so\n",
        },
    }

    # MySQLi
    file { '/etc/php5/conf.d/mysqli.ini':
        ensure  => present,
        content => $mysqli ? {
            true    => "extension=mysqli.so\n",
            default => ";extension=mysqli.so\n",
        },
    }

    # PDO
    file { '/etc/php5/conf.d/pdo.ini':
        ensure  => present,
        content => $pdo ? {
            true    => "extension=pdo.so\n",
            default => ";extension=pdo.so\n",
        },
    }

    # PDO_MySQL
    file { '/etc/php5/conf.d/pdo_mysql.ini':
        ensure  => present,
        content => $pdo ? {
            true    => "extension=pdo_mysql.so\n",
            default => ";extension=pdo_mysql.so\n",
        },
    }

    # Pecl oauth
    if ($oauth) {
        if !defined(Package['build-essential']) {
            package { 'build-essential': require => undef }
        }
                
        if !defined(Package['libpcre3-dev']) {
            package { 'libpcre3-dev': require => undef }
        }

        exec { 'pecl install oauth':
            require => Package['php-pear', 'php5-dev', 'libpcre3-dev', 'build-essential'],
            unless  => 'pecl list | grep oauth',
            notify  => $notify,
        }
    }

    file { '/etc/php5/conf.d/oauth.ini':
        ensure  => present,
        content => $oauth ? {
            true    => "extension=oauth.so\n",
            default => ";extension=oauth.so\n",
        },
    }

}
