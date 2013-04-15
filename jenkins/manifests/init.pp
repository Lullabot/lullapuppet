class jenkins (
        $jmx = false,
    ) {

    apt::source { 'jenkins':
        location    => 'http://pkg.jenkins-ci.org/debian',
        release     => 'binary/',
        repos       => '',
        include_src => false,
        key         => '10AF40FE',
        key_source  => 'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key',
    }

    package { 'jenkins':
        ensure  => present,
        require => Apt::Source['jenkins'],
    }

    service { 'jenkins':
        ensure  => running,
        enable  => true,
        require => Package['jenkins'],
    }

    file { '/etc/default/jenkins':
        ensure  => present,
        content  => template('jenkins/etc/default/jenkins.erb'),
        require => Package['jenkins'],
        notify  => Service['jenkins'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
