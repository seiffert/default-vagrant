class app::database::postgresql {

class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.2',
}
->
class { 'postgresql::server':
  ip_mask_deny_postgres_user => '0.0.0.0/32',
  ip_mask_allow_all_users    => '0.0.0.0/0',
  listen_addresses           => '*',
  ipv4acls                   => ['host all all all trust'],
  postgres_password          => "$database_rootpassword",
}

postgresql::server::role { "$database_user":
  password_hash => postgresql_password("$database_user", "$database_password"),
}

postgresql::server::db { "$database_name":
  user     => "$database_user",
  password => postgresql_password("$database_user", "$database_password"),
}

postgresql::server::pg_hba_rule { 'allow application network to access app database':
  description => "Open up postgresql for access from 127.0.0.1",
  type => 'host',
  database => "$database_name",
  user => "$database_user",
  address => '127.0.0.1/32',
  auth_method => 'md5',
}

}