Deprecation Notice
==================
The modules in this repository are certainly still useful, especially to provide
examples. But, they are no longer being developed. Instead, check out
https://github.com/Lullabot/puppet-modules for a set of modules that are
currently used in production, and are still maintained.

About This Repository
=====================
This repo is a collection of generic modules. It is designed to be cloned
to /usr/share/puppet/modules, which by default is the secondary location that
puppet will look for modules. This allows for another repo to be used for
custom modules and node manifests to glue everything together in /etc/puppet.

git clone git@github.com:Lullabot/lullapuppet.git /usr/share/puppet/modules
