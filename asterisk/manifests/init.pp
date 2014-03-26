class asterisk (
    $version = '11.8.1',
    $odbc = true,
    $opus = true
) {

    File { ensure => present }

    if !defined(Package['build-essential']) { package { 'build-essential': } }
    if !defined(Package['autoconf']) { package { 'autoconf': } }
    if !defined(Package['libncurses5-dev']) { package { 'libncurses5-dev': } }
    if !defined(Package['libssl-dev']) { package { 'libssl-dev': } }
    if !defined(Package['libxml2-dev']) { package { 'libxml2-dev': } }
    if !defined(Package['libsqlite3-dev']) { package { 'libsqlite3-dev': } }
    if !defined(Package['uuid-dev']) { package { 'uuid-dev': } }
    if !defined(Package['libnewt-dev']) { package { 'libnewt-dev': } }
    if !defined(Package['libcurl4-openssl-dev']) { package { 'libcurl4-openssl-dev': } }
    if !defined(Package['libsrtp0-dev']) { package { 'libsrtp0-dev': } }
    if !defined(Package['libiksemel-dev']) { package { 'libiksemel-dev': } }
    if !defined(Package['libneon27-dev']) { package { 'libneon27-dev': } }
    if !defined(Package['libical-dev']) { package { 'libical-dev': } }
    if !defined(Package['ntp']) { package { 'ntp': } }
    if !defined(Package['wget']) { package { 'wget': } }

    if $odbc { class { 'asterisk::odbc': } }

    user { 'asterisk':
        home  => '/var/lib/asterisk',
        shell => '/bin/bash',
    }

    exec { 'asterisk::download':
        command => "wget http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-${version}.tar.gz",
        cwd     => '/usr/local/src',
        creates => "/usr/local/src/asterisk-${version}.tar.gz",
        require => Package['build-essential', 'autoconf', 'ntp', 'libncurses5-dev', 'libssl-dev', 'libxml2-dev', 'libsqlite3-dev', 'uuid-dev', 'libnewt-dev', 'libcurl4-openssl-dev', 'libsrtp0-dev', 'libiksemel-dev', 'libneon27-dev', 'libical-dev', 'wget'],
    }

    exec { 'asterisk::unpack':
        command => "tar -zxf asterisk-${version}.tar.gz",
        cwd     => '/usr/local/src',
        creates => "/usr/local/src/asterisk-${version}",
        require => Exec['asterisk::download'],
        notify  => Exec['asterisk::bootstrap'],
    }

    # https://issues.asterisk.org/jira/browse/ASTERISK-18345
    file { '/usr/local/src/asterisk-18345.patch':
        source => 'puppet:///modules/asterisk/asterisk-18345.patch',
    }
    exec { 'asterisk::patch-18345::apply':
        command => 'patch -p 1 main/tcptls.c ../asterisk-18345.patch',
        cwd     => "/usr/local/src/asterisk-${version}",
        require => [Exec['asterisk::unpack'], File['/usr/local/src/asterisk-18345.patch']],
        before  => Exec['asterisk::bootstrap'],
        unless  => 'grep "ssl_read should block and wait for the SSL layer to provide all data" main/tcptls.c',
    }

    # https://issues.asterisk.org/jira/browse/ASTERISK-20827
    file { '/usr/local/src/asterisk-20827-11.8.x.patch':
        source => 'puppet:///modules/asterisk/asterisk-20827-11.8.x.patch',
    }
    exec { 'asterisk::patch-20827::apply':
        command => 'patch apps/app_confbridge.c ../asterisk-20827-11.8.x.patch',
        cwd     => "/usr/local/src/asterisk-${version}",
        require => [Exec['asterisk::unpack'], File['/usr/local/src/asterisk-20827-11.8.x.patch']],
        before  => Exec['asterisk::bootstrap'],
        unless  => 'grep "static void send_mute_event" apps/app_confbridge.c',
    }

    # https://github.com/samgaw/asterisk-opus
    if $opus {
        class { 'libopus': before => Exec['asterisk::bootstrap'] }

        # Recompile asterisk if libopus changes
        exec { 'asterisk::libopus':
            command     => '/bin/true',
            subscribe   => Exec['libopus::install'],
            notify      => Exec['asterisk::configure'],
            refreshonly => true,
        }

        file { '/usr/local/src/asterisk-opus-11.8.x.patch':
            source => 'puppet:///modules/asterisk/asterisk-opus-11.8.x.patch',
        }

        exec { 'asterisk::patch-opus::apply':
            command => 'patch -p1 -u < ../asterisk-opus-11.8.x.patch',
            cwd     => "/usr/local/src/asterisk-${version}",
            require => [Exec['asterisk::unpack'], File['/usr/local/src/asterisk-opus-11.8.x.patch']],
            before  => Exec['asterisk::bootstrap'],
            unless  => 'grep AST_FORMAT_OPUS channels/chan_sip.c',
        }
    }

    exec { 'asterisk::bootstrap':
        command     => "/usr/local/src/asterisk-${version}/bootstrap.sh",
        cwd         => "/usr/local/src/asterisk-${version}",
        require     => Exec['asterisk::unpack'],
        notify      => Exec['asterisk::configure'],
        refreshonly => true,
    }

    exec { 'asterisk::configure':
        command     => "/usr/local/src/asterisk-${version}/configure",
        cwd         => "/usr/local/src/asterisk-${version}",
        require     => Exec['asterisk::bootstrap'],
        notify      => Exec['asterisk::make'],
        refreshonly => true,
    }

    file { "/usr/local/src/asterisk-${version}/menuselect.makeopts":
        source  => 'puppet:///modules/asterisk/menuselect.makeopts',
        replace => false,
        require => Exec['asterisk::unpack'],
        notify  => Exec['asterisk::configure'],
        owner   => 'root',
        group   => 'root',
    }

    exec { 'asterisk::make':
        command     => 'make',
        cwd         => "/usr/local/src/asterisk-${version}",
        require     => Exec['asterisk::configure'],
        notify      => Exec['asterisk::make::install'],
        refreshonly => true,
    }

    exec { 'asterisk::make::install':
        command => 'make install',
        cwd     => "/usr/local/src/asterisk-${version}",
        require => Exec['asterisk::make'],
        notify  => Service['asterisk'],
        unless  => "/usr/sbin/asterisk -V | grep 'Asterisk ${version}'",
    }

    file { '/etc/init.d/asterisk':
        source => 'puppet:///modules/asterisk/rc.debian.asterisk',
        mode   => 0755,
        notify => Service['asterisk'],
    }

    file { '/etc/default/asterisk':
        source => 'puppet:///modules/asterisk/asterisk.default',
        notify => Service['asterisk'],
    }

    file { '/var/run/asterisk': 
        ensure  => directory,
        owner   => 'asterisk',
        group   => 'asterisk',
        require => Exec['asterisk::make::install'],
    }

    exec { 'asterisk::chown::var/lib/asterisk':
        command => 'chown -R asterisk:asterisk /var/lib/asterisk',
        require => Exec['asterisk::make::install'],
    }

    exec { 'asterisk::chown::var/spool/asterisk':
        command => 'chown -R asterisk:asterisk /var/spool/asterisk',
        require => Exec['asterisk::make::install'],
    }

    exec { 'asterisk::chown::var/log/asterisk':
        command => 'chown -R asterisk:asterisk /var/log/asterisk',
        require => Exec['asterisk::make::install'],
    }

    service { 'asterisk':
        ensure  => running,
        enable  => true,
        require => File['/etc/init.d/asterisk', '/etc/default/asterisk'],
    }

}
