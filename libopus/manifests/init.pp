class libopus ($version = '1.1') {

    if !defined(Package['build-essential']) { package { 'build-essential': } }
    if !defined(Package['wget']) { package { 'wget': } }

    exec { 'libopus::download':
        command => "wget http://downloads.xiph.org/releases/opus/opus-${version}.tar.gz",
        cwd     => '/usr/local/src',
        require => Package['wget'],
        creates => "/usr/local/src/opus-${version}.tar.gz",
    }

    exec { 'libopus::unpack':
        command => "tar -zxf opus-${version}.tar.gz",
        cwd     => '/usr/local/src',
        require => Exec['libopus::download'],
        notify  => Exec['libopus::configure'],
        creates => "/usr/local/src/opus-${version}",
    }

    exec { 'libopus::configure':
        command     => "/usr/local/src/opus-${version}/configure --prefix=/usr",
        cwd         => "/usr/local/src/opus-${version}",
        require     => [Package['build-essential'], Exec['libopus::unpack']],
        notify      => Exec['libopus::make'],
        refreshonly => true,
    }

    exec { 'libopus::make':
        command     => 'make',
        cwd         => "/usr/local/src/opus-${version}",
        require     => Exec['libopus::configure'],
        notify      => Exec['libopus::install'],
        refreshonly => true,
    }

    exec { 'libopus::install':
        command => 'make install',
        cwd     => "/usr/local/src/opus-${version}",
        require => Exec['libopus::make'],
        unless  => "diff /usr/local/src/opus-${version}/.libs/libopus.so /usr/lib/libopus.so",
    }
}
