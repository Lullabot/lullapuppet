define nodejs::module ($module = $title) {
    if !defined(Package['nodejs']) { package { 'nodejs': } }

    if !defined(Exec["nodejs::module::${module}"]) {
        exec { "nodejs::module::${module}":
            command => "npm install -g ${module}",
            require => Package['nodejs'],
            creates => "/usr/lib/node_modules/${module}",
        }
    }

}
