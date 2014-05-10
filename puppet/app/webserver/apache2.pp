class app::webserver::apache2 {
    class { "apache": mpm_module => 'prefork', default_mods => true, default_confd_files => false, default_vhost => false, }
    class { "apache::mod::php": }
    class { "apache::mod::ssl": }
    class { "apache::mod::rewrite": }

    apache::listen { '80': }
    apache::listen { '443': }
    
    package { "nginx":
        ensure => purged,
    }

    apache::vhost { "$vhost.$domain":
      port          => '80',
      servername    => "$vhost.$domain",
      docroot       => "$vhostpath/$vhost.$domain/web",
      directories   => { path => "$vhostpath/$vhost.$domain/web", allow_override => ['AuthConfig', 'Indexes', 'FileInfo', 'Options' ], },
      access_log_file => "access.log",
      error_log_file => "error.log",
      logroot => "$vhostpath/$vhost.$domain/app/logs", 
    }

    apache::vhost { "$vhost.$domain ssl":
      servername    => "$vhost.$domain",
      port     => '443',
      docroot  => "$vhostpath/$vhost.$domain/web",
      ssl      => true,
      ssl_cert => "/etc/ssl/private/$vhost$domain.crt",
      ssl_key  => "/etc/ssl/private/$vhost$domain.key",
      directories   => { path => "$vhostpath/$vhost.$domain/web", allow_override => ['AuthConfig', 'Indexes', 'FileInfo', 'Options' ], },
      access_log_file => "ssl_access.log",
      error_log_file => "ssl_error.log",
      logroot => "$vhostpath/$vhost.$domain/app/logs",  
    }


}

