class base::packages::debian {

    # Installed Packages
    if !defined(Package['bash-completion']) { package { 'bash-completion': ensure => present } }
    if !defined(Package['debconf-utils']) { package { 'debconf-utils': ensure => present } }
    if !defined(Package['git-core']) { package { 'git-core': ensure => present } }
    if !defined(Package['locate']) { package { 'locate': ensure => present } }

}
