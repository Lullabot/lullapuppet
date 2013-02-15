class apache (
        $ensure             = 'running',
        $enable             = true,
        $http_user          = undef,
        $http_group         = undef,
        $http_port          = 80,
        $https_port         = 443,
        $mod_auth_token     = false,
        $mod_authnz_ldap    = false,
        $mod_h264_streaming = false,
        $mod_headers        = false,
        $mod_passenger      = false,
        $mod_php5           = false,
        $mod_proxy          = false,
        $mod_rewrite        = true,
        $mod_ssl            = true,
        $mod_status         = true,
        ) {

    # Distribution-specific settings
    case $operatingsystem {
        redhat, centos, amazon: {
            $apache = 'httpd'
            $config = 'apache::config::redhat'
        }
        debian, ubuntu: {
            $apache = 'apache2'
            $config = 'apache::config::debian'
        }
        default: { fail('Unrecognized operating system') }
    }

    # Apache package
    package { 'apache':
        name    => $apache,
        ensure  => present,
    }

    # Apache service
    service { 'apache':
        name    => $apache,
        ensure  => $ensure,
        enable  => $enable,
        require => Package['apache'],
    }

    # Apache configuration
    class { $config:
        http_user          => $http_user,
        http_group         => $http_group,
        http_port          => $http_port,
        https_port         => $https_port,
        mod_auth_token     => $mod_auth_token,
        mod_authnz_ldap    => $mod_authnz_ldap,
        mod_h264_streaming => $mod_h264_streaming,
        mod_headers        => $mod_headers,
        mod_passenger      => $mod_passenger,
        mod_php5           => $mod_php5,
        mod_proxy          => $mod_proxy,
        mod_rewrite        => $mod_rewrite,
        mod_ssl            => $mod_ssl,
        mod_status         => $mod_status,
    }

}
