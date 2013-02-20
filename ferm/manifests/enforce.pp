class ferm::enforce {

    exec { 'ferm':
        command => '/usr/sbin/ferm /etc/ferm/ferm.conf',
    }

}
