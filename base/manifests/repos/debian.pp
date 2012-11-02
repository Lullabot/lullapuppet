class base::repos::debian {
    
    $dist = downcase($lsbdistid)

    # Apt Sources
    apt::source { 'lullabot':
        location    => "http://apt.lullabot.com/${dist}",
        release     => $lsbdistcodename,
        repos       => 'main',
        key         => '62A68384',
        key_source  => 'http://apt.lullabot.com/lullabot.com.key',
    }

    # Apt Configuration
    file { '/etc/apt/apt.conf.d/10periodic':
        ensure  => present,
        source  => 'puppet:///modules/base/debian/etc/apt/apt.conf.d/10periodic',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }

}
