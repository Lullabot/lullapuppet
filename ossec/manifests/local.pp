class ossec::local (
    $basedir                            = '/var/ossec',
    $email_notification                 = 'no',
    $email_to                           = undef,
    $email_from                         = undef,
    $smtp_server                        = 'localhost',
    $rules                              = {},
    $directories                        = {},
    $ignore                             = {},
    $whitelist                          = {},
    $log_alert_level                    = 1,
    $email_alert_level                  = 7,
    $active_response                    = 'disabled',
    $active_response_level              = '6',
    $active_response_timeout            = '600',
    $active_response_repeated_offenders = '30,60,120,720,1440',
    $localfile                          = {},
    ) {

    File {
        ensure  => present,
        owner   => 'root',
        group   => 'ossec',
        mode    => '0440',
        notify  => Service['ossec'],
    }

    service { 'ossec':
        ensure  => running,
        enable      => true,
        hasrestart  => false,
    }

    file { "${basedir}/etc/ossec.conf":
        content => template('ossec/etc/ossec.conf.erb'),
    }

    file { "${basedir}/etc/decoder.xml":
        source => 'puppet:///modules/ossec/etc/decoder.xml',
    }

    file { "${basedir}/active-response/bin/ferm-drop.sh":
        source  => 'puppet:///modules/ossec/active-response/bin/ferm-drop.sh',
        mode    => '0755',
    }

}
