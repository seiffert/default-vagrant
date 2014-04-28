class app::php {
    package {["php5", "php5-cli", "php5-dev", "php-apc", "php5-mysql", "php5-intl", "php5-curl"]:
        ensure => present,
        notify => Service[$webserverService],
    }

    exec {"clear-symfony-cache":
        require => Package["php5-cli"],
        command => "/bin/bash -c 'cd /var/www/vhosts/$vhost.$domain && /usr/bin/php app/console cache:clear --env=dev && /usr/bin/php app/console cache:clear --env=prod'",
    }

    if 'nginx' == $webserver {
        include app::php::fpm
    }
}
import "php/*.pp"