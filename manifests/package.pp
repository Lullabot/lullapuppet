# Add a define to allow installing PEAR packages.
define pear::package(
  $package = $title,
  $repository = "pear.php.net"
) {
  package { "pear-${repository}-${package}":
    name => $package,
    ensure => installed,
    provider => "pear",
    source => "${repository}/${package}",
  }
}
