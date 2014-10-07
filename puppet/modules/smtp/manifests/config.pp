class smtp::config (
$bind_ip = '127.0.0.1',
$mail_owner = 'postfix',
$smtp_server = $mail_server,
$smtp_port = $mail_port,
$smtp_username = $mail_username,
$smtp_password = $mail_password,
) {
include smtp::install

  file { "/etc/postfix/main.cf":
    ensure => present,
    content => template('smtp/main_config.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  =>  Service["postfix"],
    require => Class['smtp::install'];
  }

   service { "postfix":
    enable  => true,
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Class['smtp::install'];
  }

}


	