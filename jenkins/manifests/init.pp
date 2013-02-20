class jenkins {

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

}
