class ntp {
	package { 'ntp':
		ensure => present,
	}

	service { 'ntp':
		ensure  => running,
		require => Package['ntp'],
	}

#	if $::operatingsystem == 'Ubuntu' {
#	}

}
