class awstats {

    package { 'awstats':
        ensure => present,
    }

    file { '/var/log/awstats':
        ensure => directory,
    }
}
