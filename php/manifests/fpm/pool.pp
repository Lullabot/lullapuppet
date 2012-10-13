define php::fpm::pool (
        $user                   = 'www-data',
        $group                  = 'www-data',
        $listen                 = '127.0.0.1:9000', 
        $pm                     = 'dynamic',
        $pm_max_children        = 10,
        $pm_start_servers       = 4,
        $pm_min_spare_servers   = 2,
        $pm_max_spare_servers   = 6,
        $pm_status_path         = '/status',
        ) {

    $pool = $title

    File {
        require => Package['php5-fpm'],
        notify  => Service['php5-fpm'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

    file { '/etc/php5/fpm/pool.d/www.conf':
        content => template('php/etc/php5/fpm/pool.d/pool.conf.erb'),
    }

}
