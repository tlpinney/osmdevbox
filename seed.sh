#!/bin/sh 

# bootstrap
sudo apt-get -y install git-core ruby
git clone https://github.com/puppetlabs/puppet.git
wget http://files.rubyforge.vm.bytemark.co.uk/rubygems/rubygems-1.3.7.tgz
tar -xzvf rubygems-1.3.7.tgz 
cd rubygems-1.3.7/
sudo ruby setup.rb 
sudo ln -s /usr/bin/gem1.8 /usr/bin/gem

# boostrap puppet 
# sudo apt-get install puppet -y 

# run puppet scripts
sudo puppet apply -v /vagrant/manifests/base.pp

