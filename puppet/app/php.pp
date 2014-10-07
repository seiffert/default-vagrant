class app::php {
  
  case $::osfamily {
    Redhat: {
        require epel
        $php_package = ["php", "php-devel", "php-intl", "php-pear-Net-Curl", "php-pecl-xdebug","php-xml"]
          
          if 'mysql' == $database {
            package {
                "php-mysql":
                    ensure => present
                }
           }

          if 'postgresql' == $database {
            package {
                "php-pgsql":
                    ensure => present
                }
            }
        }
    Debian: {
        $php_package = ["php5", "php5-cli", "php5-dev", "php5-intl", "php5-curl", "php5-xdebug"]

          if 'mysql' == $database {
            package {
                "php5-mysql":
                    ensure => present
                }
           }

          if 'postgresql' == $database {
            package {
                "php5-pgsql":
                    ensure => present
                }
            }
        }
    }

  
    package { $php_package:
        ensure => present,
        notify => Service[$webserverService],
    }

    if 'nginx' == $webserver {
        include app::php::fpm
    }
}
import "php/*.pp"