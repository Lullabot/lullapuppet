class solr (
    $port   = 8983,
    ) {

    # Defaults
    File {
        ensure  => present,
        owner   => 'tomcat6',
        group   => 'tomcat6',
        mode    => '0755',
        require => Package['tomcat6'],
    }
 
    if !defined(Package['tomcat6']) { package { 'tomcat6': ensure => present } }

    service { 'tomcat6':
        ensure  => running,
        enable  => true,
        require => Package['tomcat6'],
    }

    if !defined(File['/etc/tomcat6/server.xml']) {
        file { '/etc/tomcat6/server.xml':
            ensure  => present,
            content => template('solr/etc/tomcat6/server.xml.erb'),
            require => Package['tomcat6'],
            notify  => Service['tomcat6'],
        }
    }

    file { '/var/lib/tomcat6/solr':
        ensure  => directory,
    }

    file { '/var/lib/tomcat6/solr/solr.war':
        source  => 'puppet:///modules/solr/solr/solr.war',
        require => File['/var/lib/tomcat6/solr'],
    }

    # Example solr directory
    file { '/etc/tomcat6/Catalina/localhost/example.com.xml':
        source  => 'puppet:///modules/solr/Catalina/localhost/example.com.xml',
    }
    file { '/var/lib/tomcat6/solr/example.com':
        ensure  => directory,
        source  => 'puppet:///modules/solr/solr/example.com',
        recurse => true,
    }

}
