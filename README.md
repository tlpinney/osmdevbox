Vagrant Set Up
==============

Get VirtualBox here 
https://www.virtualbox.org/wiki/Downloads

It is recommended installing it from the web site with the latest stable version.

Caveats: Check CAVEATS file

Currently migrating to lucid64 before doing a release. 
lucid64 was recently added to vagrant as a default development environment, as well it supported on an ec2 small instance. If you are still developing with maverick64 (which is default now) there is a branch available for that.


Steps:

    sudo gem install vagrant 
or 
Manually download form here: http://downloads.vagrantup.com/


    git clone https://github.com/tlpinney/osmdevbox.git 
    cd osmdevbox 
    vagrant up 

This will download the box image if its not already there 
It will start the vm, installing any necessary software 

    vagrant ssh 

Start up the development server 

    cd openstreetmap-website
    rails server 

On your host machine go to to access the rails port 
    http://127.0.0.1:3000
and go to 
    http://127.0.0.1:9080 
to access the leaflet osm debugger (currently just a stub)
 
There is a bug where the apache2 server will need to be restarted manually 
if the vm is installed from scratch...

GeoDjango
Does not automatically install 
To install (do this inside the vm)

    sudo puppet apply /vagrant/manifests/geodjango.pp

after this is done, do 

    cd
    source virtualenvs/geodjango/bin/activate
    cd demo 
    python manage.py runserver 0.0.0.0:9081 

To stop the vm
    vagrant halt 

To destroy the vm, use 
    vagrant destroy 

...this allows you to reinstall the OS from scratch 

If you want to get updates but not reinstall the OS you can update from git then do 

    vagrant provision 

...this will update puppet tasks but not have to reinstall everything from scratch

Chef Set Up
===========

NOTE: This is currently in a state of flux and probably will not work 

    sudo gem install chef knife-ec2 

Initial set up:

    mkdir ~/.chef 
    cp knife.rb ~/.chef 

Add environment variables to your profile (.profile or .bash_profile for your machine) 

    export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXX
    export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXX

Show the available servers you have 

    knife ec2 server list 

Delete a server

    knife ec2 server delete i-XXXXXXXX

Create a server 

    knife ec2 server create -r 'role[webserver]' -I ami-7000f019 -f m1.small

Chef throws an error, working on that now

