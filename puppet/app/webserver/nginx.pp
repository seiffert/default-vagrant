class app::webserver::nginx {
    package {"nginx":
        ensure => latest,
    }

    case $::osfamily {
        Redhat: {
            $apache2_package = "httpd"
        }
        Debian: {
            $apache2_package = "apache2"
        }
    }

    package {"$apache2_package":
        ensure => purged,
    }

    service {"nginx":
        ensure => running,
        hasrestart => true,
        hasstatus => true,
        require => Package["nginx"],
    }

    file {"/etc/nginx/vhosts.d":
        ensure => directory,
        owner => root,
        group => root,
        recurse => true,
        require => Package["nginx"],
    }

    file {"/etc/nginx/fastcgi_params":
        owner => root,
        group => root,
        source => "/vagrant/files/etc/nginx/fastcgi_params",
        require => Package["nginx"],
        notify => Service["nginx"],
    }

    file {"/etc/nginx/nginx.conf":
        owner => root,
        group => root,
        source => "/vagrant/files/etc/nginx/nginx.conf",
        require => Package["nginx"],
        notify => Service["nginx"],
    }

    file {"/etc/nginx/vhosts.d/$vhost$domain.conf":
        owner => root,
        group => root,
        content => template("/vagrant/files/etc/nginx/vhosts.d/template.erb"),
        require => Package["nginx"],
        notify => Service["nginx"],
    }
}
