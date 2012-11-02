class base::files::redhat {

    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

#    file { '/etc/login.defs':
#        source  => 'puppet:///modules/base/redhat/etc/login.defs',
#    }

}
