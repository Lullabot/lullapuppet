class base::files {

    case $::osfamily {
        debian: { include base::files::debian }
        redhat: { include base::files::redhat }
    }

    File {
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
