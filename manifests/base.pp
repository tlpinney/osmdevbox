 group { "puppet":
   ensure => "present",
 }

 File { owner => 0, group => 0, mode => 0644 }

 file { '/etc/motd':
   content => "Welcome to your OpenStreetMap Dev Box v0.2!"
 }

user { "vagrant":
  ensure     => "present",
  managehome => true,
}

 package { "git-core":
  ensure => installed,
 }

 package { "vim":
  ensure => installed,
 }

 package { "postgresql-contrib":
  ensure => installed,
 }


 package { "ruby":
  ensure => installed,
 }

 package { "rdoc":
  ensure => installed,
 }

 package { "ri":
  ensure => installed,
 }

 package { "libpq-dev":
  ensure => installed,
 }

 package { "libxml2-dev":
 ensure => installed,
 }

 package { "libxslt1-dev":
 ensure => installed,
 }

 package { "ruby-dev":
 ensure => installed,
 }

 package { "apache2-dev":
 ensure => installed,
 }

 package { "libmagick9-dev":
 ensure => installed,
 }

package { "build-essential":
 ensure => installed,
 }

package { "libopenssl-ruby":
 ensure => installed,
 }

package { "subversion":
 ensure => installed,
 }

package { "apache2":
 ensure => installed,
 }


package { "postgresql": 
 ensure => installed,
}

package { "libcurl4-openssl-dev":
  ensure => installed,
}

package { "expect":
  ensure => installed,
}

package { "expect-dev":
  ensure => installed,
}

package { "libsasl2-dev":
  ensure => installed,
}



exec { "osm_git":
  cwd => "/home/vagrant",
  user => "vagrant",
  command => "/usr/bin/git clone https://github.com/openstreetmap/openstreetmap-website.git",
  creates => "/home/vagrant/openstreetmap-website",
  require => [Package["git-core"]],
} 


exec { "Set up database":
  cwd => "/var/lib/postgresql",
  user => "postgres",
  command => "/bin/sh /vagrant/manifests/osm_database.sh",
  creates => "/var/lib/postgresql/database_setup.log",
  logoutput => "true",
  require => [ Package["postgresql-contrib"] ]
} 




file { "/etc/apache2/conf.d/passenger" :
   owner => root,
   group => root,
   source => "/vagrant/configs/passenger",
   mode => 644
}

file { "/home/vagrant/.profile" :
   owner => vagrant,
   group => vagrant,
   source => "/vagrant/configs/profile",
   mode => 644
}

file { "/home/vagrant/openstreetmap-website/config/database.yml" :
   owner => vagrant,
   group => vagrant,
   source => "/vagrant/configs/database.yml",
   mode => 644,
   require => [Exec["osm_git"]]
}


file { "/home/vagrant/openstreetmap-website/config/application.yml" :
   owner => vagrant,
   group => vagrant,
   source => "/home/vagrant/openstreetmap-website/config/example.application.yml",
   mode => 644,
   require => [File["/home/vagrant/openstreetmap-website/config/database.yml"]]

}

exec { "Set up gems and various things":
  cwd => "/home/vagrant",
  user => "vagrant",
  command => "/bin/sh /vagrant/manifests/gems.sh",
  creates => "/home/vagrant/gems_setup.log",
  logoutput => "true",
  require => [File["/home/vagrant/openstreetmap-website/config/application.yml"]]
} 
