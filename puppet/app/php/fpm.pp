class app::php::fpm {

    package { "$fpmpackage":
            ensure => present,
            notify => Service[$webserver],
    }


    file {"$poolpath":
        ensure => directory,
        owner => root,
        group => root,
        require => [Package["$fpmpackage"]],
    }

    file {"$poolpath/$vhost$domain.conf":
        ensure => present,
        owner => root,
        group => root,
        content => template("/vagrant/files/etc/php5/fpm/pool.d/template.erb"),
        require => [File["$poolpath"]],
        notify => Service["$servicename", "nginx"],
    }

    service {"$servicename":
        ensure => running,
        hasrestart => true,
        hasstatus => true,
        require => [Package[$fpmpackage]],
    }
}
