class app::webserver::apache2 {
    class { "apache": }
    class { "apache::mod::php": }

    package { "nginx":
        ensure => purged,
    }

    file {"/etc/apache2/sites-enabled/000-default":
        ensure => absent,
        notify => Service["httpd"],
    }

    file {"/etc/apache2/sites-enabled/$vhost$domain.conf":
        ensure => present,
        content => template("/vagrant/files/etc/apache2/sites-available/template.erb"),
        require => Package["httpd"],
        notify => Service["httpd"],
    }

    a2mod { 'rewrite': ensure => present, }
}
