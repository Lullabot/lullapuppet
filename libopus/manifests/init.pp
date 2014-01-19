class libopus ($release = 'opus-1.0.3') {

    if !defined(Package['build-essential']) { package { 'build-essential': } }
    if !defined(Package['wget']) { package { 'wget': } }

    exec { 'libopus::download':
        command => "wget http://downloads.xiph.org/releases/opus/$release.tar.gz",
        cwd     => '/usr/local/src',
        creates => "/usr/local/src/$release.tar.gz",
        require => Package['wget'],
    }

    exec { 'libopus::unpack':
        command => "tar -zxf $release.tar.gz",
        cwd     => '/usr/local/src',
        require => Exec['libopus::download'],
        creates => "/usr/local/src/$release",
    }

    exec { 'libopus::configure':
        command => "/usr/local/src/$release/configure --prefix=/usr",
        cwd     => "/usr/local/src/$release",
        require => [Package['build-essential'], Exec['libopus::unpack']],
        creates => "/usr/local/src/$release/config.log",
    }

    exec { 'libopus::make':
        command => 'make',
        cwd     => "/usr/local/src/$release",
        require => Exec['libopus::configure'],
        notify  => Exec['libopus::install'],
        creates => "/usr/local/src/$release/libopus.la",
    }

    exec { 'libopus::install':
        command     => 'make install',
        cwd         => "/usr/local/src/$release",
        refreshonly => true,
    }
}
