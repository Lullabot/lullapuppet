class asterisk::opus {
    include asterisk::params

    if !defined(Package['git']) { package { 'git': } }
    if !defined(Package['build-essential']) { package { 'build-essential': } }

    class { 'libopus': before => Exec['asterisk::bootstrap'] }

    exec { 'asterisk::patch-opus::download':
        command => 'git clone https://github.com/netaskd/asterisk-opus.git',
        cwd     => '/usr/local/src',
        creates => '/usr/local/src/asterisk-opus',
        require => Package['git'],
    }

    exec { 'asterisk::patch-opus::apply':
        command => 'patch -p1 -u < ../asterisk-opus/asterisk-11.5.0_opus+vp8.diff',
        cwd     => "/usr/local/src/$asterisk::params::release",
        require => Exec['asterisk::unpack', 'asterisk::patch-opus::download'],
        before  => Exec['asterisk::bootstrap'],
        unless  => 'grep AST_FORMAT_OPUS channels/chan_sip.c',
    }
}
