class ferm::enforce {

    exec { 'ferm':
        command => '/usr/sbin/ferm /etc/ferm/ferm.conf',
    }

    if $::osfamily == Redhat {
        exec { '/etc/init.d/iptables save':
            require => Exec['ferm'],
        }
    }

}
