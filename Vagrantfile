# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "maverick64"
  config.vm.box_url = "https://s3.amazonaws.com/osmdevbox/maverick64.box"
 

config.vm.customize [
  "modifyvm", :id,
  "--name", "OpenStreetMap Dev VM v0.2",
  "--memory", "2048"
] 

config.vm.forward_port(80, 9080)
config.vm.forward_port(3000, 3000)


  config.vm.provision :puppet, :options => "--verbose" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "base.pp"
  end

end
