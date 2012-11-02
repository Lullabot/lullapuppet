class base::files::debian {

    $distpath = "${operatingsystem}.${lsbdistcodename}"

    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

#    file { '/etc/adduser.conf':
#        source  => 'puppet:///modules/base/debian/etc/adduser.conf',
#    }

#    file { '/etc/login.defs':
#        source  => $operatingsystem ? {
#            ubuntu  => "puppet:///modules/base/${distpath}/etc/login.defs",
#            default => 'puppet:///modules/base/debian/etc/login.defs',
#        }
#    }

#    if $operatingsystem == 'ubuntu' {
#        file { '/etc/update-motd.d/09-lullabot':
#            content => template('base/etc/update-motd.d/09-lullabot.erb'),
#            mode    => '0755',
#        }
#    }

}
