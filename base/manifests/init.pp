class base {

    # Distro-agnostic settings
    if !defined(Package['less']) {
        package { 'less': ensure => present }
    }

    if !defined(Package['lsof']) {
        package { 'lsof': ensure => present }
    }

    if !defined(Package['nmap']) {
        package { 'nmap': ensure => present }
    }

    if !defined(Package['strace']) {
        package { 'strace': ensure => present }
    }

    if !defined(Package['tcpdump']) {
        package { 'tcpdump': ensure => present }
    }

    if !defined(Package['traceroute']) {
        package { 'traceroute': ensure => present }
    }

    if !defined(Package['wget']) {
        package { 'wget': ensure => present }
    }

    # Distro-specific settings
    case $::osfamily {
        debian: {
            $git = 'git-core'
            $locate = 'locate'
            if !defined(Package['bash-completion']) {
                package { 'bash-completion': ensure => present }
            }

            if !defined(Package['debconf-utils']) {
                package { 'debconf-utils': ensure => present }
            }

            if !defined(Package['ssl-cert']) {
                package { 'ssl-cert': ensure => present }
            }

            file { '/etc/apt/apt.conf.d/10periodic':
                ensure  => present,
                source  => 'puppet:///modules/base/etc/apt/apt.conf.d/10periodic',
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
            }
        }

        redhat: {
            $git = 'git'
            $locate = 'mlocate'
        }
    }

    if !defined(Package[$git]) {
        package { $git: ensure => present }
    }

    if !defined(Package[$locate]) {
        package { $locate: ensure => present }
    }

}
