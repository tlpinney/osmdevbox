
if [ ! -f "/home/vagrant/node_install.log" ]; then 
cd /home/vagrant && wget http://nodejs.org/dist/v0.6.11/node-v0.6.11.tar.gz && tar xzf node-v0.6.11.tar.gz && cd node-v0.6.11 && ./configure && make && sudo make install && touch /home/vagrant/node_install.log 
else
echo "nodejs already installed!"
fi 

if [ ! -f "/home/vagrant/npm_install.log" ]; then
cd /home/vagrant && sudo curl http://npmjs.org/install.sh | sudo sh && touch /home/vagrant/npm_install.log
else
echo "npm already installed!"
fi 


