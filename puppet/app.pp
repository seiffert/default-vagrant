Exec { path => ['/usr/local/bin', '/opt/local/bin', '/usr/bin', '/usr/sbin', '/bin', '/sbin'], logoutput => true }

  case $::osfamily {
    Debian: {
            Package { require => Exec['apt_update'], }

            class { 'apt':
              always_apt_update    => true
            }
        $sslpath =  "/etc/ssl/private"
        $poolpath = "/etc/php5/fpm/pool.d/"
        $servicename = "php5-fpm"
        $fpmpackage = "php5-fpm"
        $fpmsocketpath = "/run/shm"
        }
    Redhat: {
        $sslpath =  "/etc/pki/tls/private"
        $poolpath = "/etc/php-fpm.d"
        $servicename = "php-fpm"
        $fpmpackage = "php-fpm"
        $fpmsocketpath = "/dev/shm"
    }
  }


import "app/*.pp"

$webserverService = $webserver ? {
    apache2 => 'httpd',
    nginx => 'nginx',
    default => 'nginx'
}

class { 'smtp::config': }

host { 'localhost':
    ip => '127.0.0.1',
    host_aliases => ["localhost.localdomain",
                     "localhost4", "localhost4.localdomain4", "$vhost.$domain"],
    notify => Service[$webserverService],
}

include app::php
include app::webserver
include app::tools
include app::database
include app::ssl
include app::commands
