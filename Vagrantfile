# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "lucid32"

config.vm.customize [
  "modifyvm", :id,
  "--name", "OpenStreetMap Dev VM v0.1",
  "--memory", "2048"
] 

config.vm.forward_port(80, 9080)
config.vm.forward_port(3000, 3000)


  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "base.pp"
  end

end
