define apache::vhost (
    $enabled = true,
    ) {

    $vhost = $title
    $package = 'apache2'
    $service = 'apache2'
    $confdir = 'apache2'

    file { "/etc/${confdir}/sites-available/${vhost}":
        ensure  => present,
        source  => "puppet:///modules/apache/etc/${confdir}/sites-available/${vhost}",
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => File["/etc/${confdir}/sites-available"],
        notify  => Service[$service],
    }

    file { "/etc/${confdir}/sites-enabled/${vhost}":
        ensure  => $enabled ? {
            true    => "/etc/${confdir}/sites-available/${vhost}",
            default => 'absent',
        },
        require => File["/etc/${confdir}/sites-available/${vhost}",
                        "/etc/${confdir}/sites-enabled"],
        notify  => Service[$service],
    }

}
