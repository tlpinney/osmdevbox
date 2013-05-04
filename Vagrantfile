# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
 

config.vm.customize [
  "modifyvm", :id,
  "--name", "OpenStreetMap Dev VM v0.9.2",
  "--memory", "2048"
] 

# apache
config.vm.forward_port(80, 9080)

# geodjango 
config.vm.forward_port(9081, 9081)

# rails port
config.vm.forward_port(3000, 3000)


  config.vm.provision :puppet, :options => "--verbose" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "base.pp"
  end

end
