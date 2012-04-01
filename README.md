Vagrant Set Up
==============

Get VirtualBox here 
https://www.virtualbox.org/wiki/Downloads

It is recommended to use 4.1.8 instead of installing from a package manager 
because the guest modifications on the bare vm are made for that version.

Caveats:

Make sure you have virtualization extensions enabled in your BIOS. It may not 
run if this is not set up, and you will want to be running on a 64bit system.

Running ubuntu 11.10 I ran into an issue with current user not being in 
"vboxusers" (so it failed to start. If your vm hangs when running "vagrant up",
open up the virtualbox program and try to run the virtual machine inside of 
there. It may give you more debugging messages.


Steps:

    sudo gem install vagrant 

    git clone https://github.com/tlpinney/osmdevbox.git 
    cd osmdevbox 
    vagrant up 

This will download the box image if its not already there 
It will start the vm, installing any neccesary software 

    vagrant ssh 

Start up the development server 

    cd openstreetmap-website
    rails server 

On your host machine go to to access the rails port http://127.0.0.1:3000
and go to http://127.0.0.1:9080 to access the leaflet osm debugger currently
this is stub code tha shows an osm map 

There is a bug where the apache2 server will need to be restarted manually 
if the vm is installe from scratch...

# GeoDjango
# Does not automatically install 
# To install (do this inside the vm)
sudo puppet apply /vagrant/manifests/geodjango.pp
# after this is done, do 
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

