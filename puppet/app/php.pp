class app::php {
  
  case $::osfamily {
    Redhat: {
        $php_package = ["php", "php-dev", "php-mysql", "php-intl", "php-curl", "php-xdebug"]
    }
    Debian: {
        $php_package = ["php5", "php5-cli", "php5-dev", "php5-mysql", "php5-intl", "php5-curl", "php5-xdebug"]
    }
  }
  
    package { $php_package:
        ensure => present,
        notify => Service[$webserverService],
    }

    exec {"clear-symfony-cache":
        require => Package["php5-cli"],
        command => "/bin/bash -c 'cd $vhostpath/$vhost.$domain && /usr/bin/php app/console cache:clear --env=dev && /usr/bin/php app/console cache:clear --env=prod'",
    }

    if 'nginx' == $webserver {
        include app::php::fpm
    }
}
import "php/*.pp"