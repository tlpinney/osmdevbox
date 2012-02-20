sudo gem install passenger
expect /vagrant/manifests/pfusion.exp
sudo gem install bundler 
cd /home/vagrant/openstreetmap-website
sudo bundle install
sudo gem install rails 
touch /home/vagrant/gems_setup.log


