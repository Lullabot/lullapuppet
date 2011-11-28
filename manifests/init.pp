class pear(
  $package = $pear::params::package
) inherits pear::params {

  # Install the PEAR package.
  package { $package:
    ensure => installed,
  }

  # Add a define to allow installing PEAR packages.
  define pear::package( 
    $package = $title,
    $repository = "pear.php.net",
  ) {
    include pear

    package { "pear-${repository}-${package}":
      ensure => installed,
      provider => "pear",
      source => "${repository}/${package}",
    }
  }
}

