class base::packages::redhat {

    # Installed Packages
    if !defined(Package['git']) { package { 'git': ensure => present } }
    if !defined(Package['mlocate']) { package { 'mlocate': ensure => present } }

}
