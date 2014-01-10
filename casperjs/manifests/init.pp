class casperjs (
    $phantomjs = '1.9.2-linux-x86_64',
) {

    if !defined(Package['git']) { package { 'git': } }
    if !defined(Package['wget']) { package { 'wget': } }

    exec { 'casperjs::download':
        command => 'git clone git://github.com/n1k0/casperjs.git /usr/local/share/casperjs',
        creates => '/usr/local/share/casperjs',
        require => Package['git'],
    }

    exec { 'phantomjs::download':
        command => "wget https://phantomjs.googlecode.com/files/phantomjs-${phantomjs}.tar.bz2",
        cwd     => '/usr/local/share',
        creates => "/usr/local/share/phantomjs-${phantomjs}.tar.bz2",
    }

    exec { 'phantomjs::install':
        command => "tar -jxf phantomjs-${phantomjs}.tar.bz2",
        cwd     => '/usr/local/share',
        creates => "/usr/local/share/phantomjs-${phantomjs}",
    }

    file { '/usr/local/bin/phantomjs':
        ensure  => "/usr/local/share/phantomjs-${phantomjs}/bin/phantomjs",
        require => Exec['phantomjs::install'],
    }

    file { '/usr/local/bin/casperjs':
        ensure  => '/usr/local/share/casperjs/bin/casperjs',
        require => Exec['casperjs::download'],
    }

}
