

package { "python-pip":
 ensure => installed,
}

package { "python-virtualenv":
 ensure => installed,
}

package { "postgis":
 ensure => installed,
}

package { "ipython":
 ensure => installed,
}


package { "libgeos-3.2.0":
 ensure => installed,
}

package { "gdal-bin":
 ensure => installed,
}

package { "proj":
 ensure => installed,
}

package { "postgresql-8.4-postgis":
 ensure => installed,
}





exec { "geodjango_virtualenv":

  cwd => "/home/vagrant",
  user => "vagrant",
  command => "/usr/bin/virtualenv virtualenvs/geodjango",
  creates => "/home/vagrant/virtualenvs/geodjango",
  require => [Package["python-virtualenv"], Package["python-pip"], Package["ipython"]],
}


exec { "django_install":
  cwd => "/home/vagrant",
  user => "vagrant",
  path => ["/home/vagrant/virtualenvs/geodjango/bin"],
  environment => ["VIRTUAL_ENV=/home/vagrant/virtualenvs/geodjango"], 
  command => 'pip install django && /bin/mkdir /home/vagrant/django_ilogs && /usr/bin/touch /home/vagrant/django_ilogs/django.log',
  creates => "/home/vagrant/django_ilogs/django.log",
  require => [Exec["geodjango_virtualenv"]],
}


exec { "setup_postgis":
  cwd => "/vagrant/manifests",
  user => "postgres",
  command => "/bin/sh ./create_template_postgis-debian.sh && /usr/bin/touch /var/lib/postgresql/postgis_setup.log",
  creates => "/var/lib/postgresql/postgis_setup.log",
  require => [Package["postgresql-8.4-postgis"], Package["proj"], Package["libgeos-3.2.0"] ],
}

# in the future create a specific user for a django application
# need to somehow check if this already exists  (will exist from the rails port install)
#exec { "createuser_vagrant":
#  cwd => "/vagrant/manifest",
#  user => "postgres",
#  command => "/bin/sh ./create_template_postgis-debian.sh && /usr/bin/touch /var/lib/postgresql/postgis_setup.log",
#  creates => "/var/lib/postgresql/postgis_setup.log",
#  require => [Package["postgresql-8.4-postgis"], Package["proj"], Package["libgeos-3.2.0"] ],
#}


# create the demo django app 
exec { "demo_install":
  cwd => "/home/vagrant",
  user => "vagrant",
  path => ["/home/vagrant/virtualenvs/geodjango/bin"],
  environment => ["VIRTUAL_ENV=/home/vagrant/virtualenvs/geodjango"], 
  command => 'django-admin.py startproject demo && /usr/bin/touch /home/vagrant/django_ilogs/demo.log',
  creates => "/home/vagrant/django_ilogs/demo.log",
  require => [Exec["setup_postgis"]],
}

# create an osm django app
exec { "demo_osm_install":
  cwd => "/home/vagrant/demo",
  user => "vagrant",
  path => ["/home/vagrant/virtualenvs/geodjango/bin"],
  environment => ["VIRTUAL_ENV=/home/vagrant/virtualenvs/geodjango"], 
  command => 'python manage.py startapp osm && /usr/bin/touch /home/vagrant/django_ilogs/demo_osm.log',
  creates => "/home/vagrant/django_ilogs/demo_osm.log",
  require => [Exec["demo_install"]],
}



# cd 
# mkdir data
# cd data
