class s3cmd {

    # RedHat & derivitives do not have s3cmd in the default repo
    if $osfamily == 'RedHat' {
        $repo = $operatingsystemrelease ? {
            /^5/    => "http://s3tools.org/repo/RHEL_5/s3tools.repo",
            /^6/    => "http://s3tools.org/repo/RHEL_6/s3tools.repo",
        }

        if !defined(Package['wget']) {
            package { 'wget': }
        }

        exec { "install $repo":
            command => "wget -q -O /etc/yum.repos.d/s3tools.repo $repo",
            unless  => 'grep "\[s3tools\]" /etc/yum.repos.d/s3tools.repo',
            notify  => Package['s3cmd'],
            require => Package['wget'],
        }
    }

    package { 's3cmd':
        ensure  => present,
    }
}
