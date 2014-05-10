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
    v.memory = 512
    v.cpus = 1
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
                                "mysql_rootpassword" => $mysql_rootpassword,
                                "mysql_user" => $mysql_user,
                                "mysql_password" => $mysql_password,
                                "mysql_database" => $mysql_database,
                              }
  end
end
