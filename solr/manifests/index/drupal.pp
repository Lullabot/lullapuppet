define solr::index::drupal(
    $version    = '7.x-1.0-rc2',
    ) {

    # Defaults
    File {
        ensure  => present,
        owner   => 'tomcat6',
        group   => 'tomcat6',
        mode    => '0644',
        require => Package['tomcat6'],
    }
 
    file { ["/var/lib/tomcat6/solr/${title}", "/var/lib/tomcat6/solr/${title}/conf"]:
        ensure  => directory,
    }

    exec { "configure ${title} index":
        command => "cp -r /var/lib/tomcat6/solr/example.com/conf/* /var/lib/tomcat6/solr/${title}/conf/ && wget -q -O- http://ftp.drupal.org/files/projects/apachesolr-${version}.tar.gz | tar -C /var/lib/tomcat6/solr/${title}/conf --strip 2 -zxf - --wildcards \"apachesolr/solr-conf/*\" && echo ${version} > /var/lib/tomcat6/solr/${title}/conf/version.txt && chown -R tomcat6:tomcat6 /var/lib/tomcat6/solr/${title}/conf",
        require => File['/var/lib/tomcat6/solr/example.com',
                        "/var/lib/tomcat6/solr/${title}/conf"],
        unless  => "grep ${version} /var/lib/tomcat6/solr/${title}/conf/version.txt",
        notify  => Service['tomcat6'],
    }

    file { "/etc/tomcat6/Catalina/localhost/$title.xml":
        content => template('solr/etc/tomcat6/Catalina/localhost/solr.xml.erb'),
        notify  => Service['tomcat6'],
    }
}
