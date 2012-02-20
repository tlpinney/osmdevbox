#!/bin/sh 

# bootstrap
sudo apt-get install git-core ruby -y
git clone https://github.com/tlpinney/osmdevbox.git 
git clone https://github.com/puppetlabs/puppet.git
wget http://files.rubyforge.vm.bytemark.co.uk/rubygems/rubygems-1.3.7.tgz
tar -xzvf rubygems-1.3.7.tgz 
cd rubygems-1.3.7/
sudo ruby setup.rb 
sudo ln -s /usr/bin/gem1.8 /usr/bin/gem

# boostrap puppet 
# sudo apt-get install puppet -y 

# run puppet scripts
sudo uppet apply -v osmdevbox/manifests/base.pp

