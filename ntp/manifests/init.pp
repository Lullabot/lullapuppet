class ntp {
	package { 'ntp':
		ensure => present,
	}

    $ntpd = $::osfamily ? {
        Debian  => 'ntp',
        RedHat  => 'ntpd',
        default => 'ntp',
    }

	service { 'ntp':
        name    => $ntpd,
		ensure  => running,
        enable  => true,
		require => Package['ntp'],
	}
}
