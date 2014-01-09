class selenium (
    $version = '2.39.0',
) {

    if !defined(Package['default-jdk']) { package { 'default-jdk': } }
    if !defined(Package['firefox']) { package { 'firefox': } }
    if !defined(Package['wget']) { package { 'wget': } }
    if !defined(Package['xvfb']) { package { 'xvfb': } }

    file { '/etc/init.d/xvfb':
        source => 'puppet:///modules/selenium/etc/init.d/xvfb',
        mode   => '0755',
    }

    service { 'xvfb':
        ensure    => running,
        enable    => true,
        hasstatus => false,
        status    => 'ps -h --pid `cat /var/run/xvfb.pid`',
        require   => File['/etc/init.d/xvfb'],
    }

    exec { 'selenium::download':
        command => "wget http://selenium.googlecode.com/files/selenium-server-standalone-${version}.jar",
        cwd     => '/usr/local/share',
        require => Package['wget'],
        creates => "/usr/local/share/selenium-server-standalone-${version}.jar",
    }

    file { '/usr/local/share/selenium-server-standalone.jar':
        ensure  => "/usr/local/share/selenium-server-standalone-${version}.jar",
        require => Exec['selenium::download'],
    }
}
