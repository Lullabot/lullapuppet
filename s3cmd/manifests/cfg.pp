define s3cmd::cfg (
    $user = $title,
	$group = $title,
    $home = "/home/$title",
    $access_key,
    $gpg_passphrase,
    $secret_key,
    $use_https = 'False',
    ) {

    file { "$home/.s3cfg":
        ensure  => present,
        content => template('s3cmd/s3cfg.erb'),
        owner   => $user,
        group   => $group,
        mode    => 0600,
    }
}
