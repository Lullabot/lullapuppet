## Introduction

This module installs PEAR from a package manager and aids you in installing
the latest versions (or specified versions) of PEAR packages.

## Credit

This code is taken from https://gist.github.com/305778, which is itself based on
http://www.mit.edu/~marthag/puppet/pear.rb.

You can see all the changes that have been made since the initial commit at the
following URL:

https://github.com/smerrill/puppet-pear/commits/master/lib/puppet/provider/package/pear.rb

## Example usage

This module will try to install PEAR via the package name `php-pear` (this is
also configurable) and will then allow the installation of PEAR packages
through the pear::package function.

Here is an example of installing the default `php-pear` package and upgrading
PEAR, then installing Console_Table and drush 4.5.0 from a third-party PEAR
repository.

```puppet
include pear
# If no version number is supplied, the latest stable release will be
# installed. In this case, upgrade PEAR to 1.9.2+ so it can use
# pear.drush.org without complaint.
pear::package { "PEAR": }
pear::package { "Console_Table": }
# Version numbers are supported.
pear::package { "drush":
  version => "4.5.0",
  repository => "pear.drush.org",
}
```
