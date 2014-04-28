class app::ssl {
require webserver

openssl::certificate::x509 { "$vhost$domain":
  ensure       => present,
  country      => 'US',
  organization => 'SSL Inc.',
  commonname   => "*.$vhost.$domain",
  state        => 'New York',
  locality     => 'New York',
  unit         => 'IT Depermant',
  email        => "developer@$vhost.$domain",
  days         => 3456,
  base_dir     => '/etc/ssl/private',
  owner        => 'root',
  force        => false,
}

}

