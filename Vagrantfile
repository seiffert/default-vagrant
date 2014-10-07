# -*- mode: ruby -*-
# vi: set ft=ruby :

personalization = File.expand_path("../Personalization", __FILE__)
load personalization

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = $base_box

  config.vm.host_name = $vhost + "." + $domain

  config.vm.network "private_network", ip: $ip

  config.vm.synced_folder  "../", $vhostpath + "/" + $vhost + "." + $domain, type: "nfs"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    v.memory = $memory
    v.cpus = $cpu
  end

  config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet"
      puppet.manifest_file  = "app.pp"
      puppet.module_path    = "puppet/modules"
      puppet.facter         = {
                                "vhost" => $vhost,
                                "domain" => $domain,
                                "webserver" => $webserver,
                                "vhostpath" => $vhostpath,
                                "database_rootpassword" => $database_rootpassword,
                                "database_user" => $database_user,
                                "database_password" => $database_password,
                                "database_name" => $database_name,
                                "database" => $database,
                                "mail_server" => $mail_server,
                                "mail_port" => $mail_port,
                                "mail_username" => $mail_username,
                                "mail_password" => $mail_password,
                                "timezone" => $timezone
                              }
  end
end
