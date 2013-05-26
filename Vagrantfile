# -*- mode: ruby -*-
# vi: set ft=ruby :

personalization = File.expand_path("../Personalization", __FILE__)
load personalization

Vagrant::Config.run do |config|
  config.vm.box = $base_box

  config.vm.host_name = $vhost + ".dev"

  config.vm.network :hostonly, $ip

  config.vm.share_folder $vhost, "/srv/www/vhosts/" + $vhost + ".dev", "../", :nfs => $use_nfs

  config.vm.customize ["modifyvm", :id, "--memory", "512"]

  config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet"
      puppet.manifest_file  = "app.pp"
      puppet.module_path    = "puppet/modules"
      puppet.facter         = {
                                "vhost" => $vhost,
                                "webserver" => $webserver
                              }
  end
end
