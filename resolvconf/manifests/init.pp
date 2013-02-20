class resolvconf (
    $nameserver,
    $search,
    $domain = '',
    ) {

    file { '/etc/resolv.conf':
        content => template('resolvconf/etc/resolv.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

}
