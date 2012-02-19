wget http://files.rubyforge.vm.bytemark.co.uk/rubygems/rubygems-1.3.7.tgz
tar -xzvf rubygems-1.3.7.tgz 
cd rubygems-1.3.7/
sudo ruby setup.rb 
sudo ln -s /usr/bin/gem1.8 /usr/bin/gem
sudo gem install passenger
expect /vagrant/manifests/pfusion.exp
sudo gem install bundler 
cd /home/vagrant/openstreetmap-website
sudo bundle install
sudo gem install rails 


