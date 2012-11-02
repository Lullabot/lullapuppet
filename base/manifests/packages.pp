class base::packages {

    case $::osfamily {
        debian: { include base::packages::debian }
        redhat: { include base::packages::redhat }
    }

    # Installed Packages
    if !defined(Package['less']) { package { 'less': ensure => present } }
    if !defined(Package['lsof']) { package { 'lsof': ensure => present } }
    if !defined(Package['nmap']) { package { 'nmap': ensure => present } }
    if !defined(Package['strace']) { package { 'strace': ensure => present } }
    if !defined(Package['tcpdump']) { package { 'tcpdump': ensure => present } }
    if !defined(Package['traceroute']) { package { 'traceroute': ensure => present } }
    if !defined(Package['wget']) { package { 'wget': ensure => present } }

}
