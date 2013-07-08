define ferm::rule(
    $table      = 'filter',
    $chain      = 'INPUT',
    $interface  = undef,
    $outerface  = undef,
    $proto      = 'tcp',
    $sport      = undef,
    $dport      = undef,
    $saddr      = '0.0.0.0/0',
    $daddr      = '0.0.0.0/0',
    $action     = 'ACCEPT',
    $ossec      = undef,
    ) {

    $dir = $ossec ? {
        exempt  => 'ossec.exempt.d',
        default => 'ferm.d',
    }

    $int = $interface ? {
        undef   => '',
        default => " interface ($interface)",
    }

    $out = $outerface ? {
        undef   => '',
        default => " outerface ($outerface)",
    }

    $spt = $sport ? {
        undef   => '',
        default => " sport ($sport)",
    }

    $dpt = $dport ? {
        undef   => '',
        default => " dport ($dport)",
    }

    $protocol = $proto ? {
        any   => '',
        default => " proto ($proto)",
    }

    file { "/etc/ferm/${dir}/${title}.ferm":
        ensure  => present,
        content => "table $table chain $chain$int$out$protocol saddr ($saddr)$spt daddr ($daddr)$dpt $action;\n",
        require => File['/etc/ferm/ferm.d'],
    }

}
