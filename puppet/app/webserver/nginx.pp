class app::webserver::nginxserver {
require app::ssl

class { 'nginx': }


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

nginx::resource::vhost { "$vhost.$domain":
  ensure => 'present',
  www_root => "$vhostpath/$vhost.$domain/web",
  index_files => [ 'app_dev.php'],
  try_files   => [ '$uri', '@rewriteindex'],
  ssl         => true,
  ssl_cert    => "$sslpath/$vhost$domain.crt",
  ssl_key     => "$sslpath/$vhost$domain.key",
  access_log  => "$vhostpath/$vhost.$domain/app/logs/access.log",
  error_log   => "$vhostpath/$vhost.$domain/app/logs/error.log",
}

nginx::resource::location { 'location-rewriteindex':
    ensure  => present,
    ssl     => true,
    vhost   => "$vhost.$domain",
    www_root    => "$vhostpath/$vhost.$domain/web",
    location    => '@rewriteindex',
    rewrite_rules => ['^(.*)$ /app.php/$1 last'],

}


nginx::resource::location { 'location-phpfpm':
      ensure          => present,
      ssl             => true,
      vhost           => "$vhost.$domain",
      www_root        => "$vhostpath/$vhost.$domain/web",
      location        => '~ ^/(app|app_dev)\.php(/|$)',
      proxy           => undef,
      fastcgi         => "unix:$fpmsocketpath/$vhost$domain.phpfpm.socket",
      location_cfg_append => {
        fastcgi_connect_timeout => '3m',
        fastcgi_read_timeout    => '3m',
        fastcgi_send_timeout    => '3m',
        fastcgi_split_path_info => '^(.+\.php)(/.*)$',
        include                 => 'fastcgi_params',
        fastcgi_param           =>  'SCRIPT_FILENAME $document_root$fastcgi_script_name',
      }
}
    

}