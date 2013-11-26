class app::webserver::nginx {
    package {"nginx":
        ensure => latest,
    }

    package {"httpd":
        ensure => purged,
    }

    service {"nginx":
        ensure => running,
        hasrestart => true,
        hasstatus => true,
        require => [Package["nginx"], Package["httpd"]],
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

    file {"/etc/nginx/vhosts.d/$vhost.dev.conf":
        owner => root,
        group => root,
        content => template("/vagrant/files/etc/nginx/vhosts.d/app.dev.conf"),
        require => Package["nginx"],
        notify => Service["nginx"],
    }
}
