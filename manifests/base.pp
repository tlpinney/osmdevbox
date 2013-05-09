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

exec { "/usr/bin/apt-get update -y":
  user => "root",
  timeout => 3600,
}

exec { "/usr/bin/apt-get upgrade -y":
  user => "root",
  timeout => 3600,
  require => [ Exec["/usr/bin/apt-get update -y"] ]
}

package { ["git-core", "vim", "postgresql-contrib", "ruby", "rdoc", "ri",
           "libpq-dev", "libxml2-dev", "libxslt1-dev", "ruby-dev", "apache2-dev",
           "graphicsmagick-libmagick-dev-compat", "build-essential", "libopenssl-ruby",
           "subversion", "apache2", "postgresql-9.1", "libcurl4-openssl-dev",
           "expect", "expect-dev", "libsasl2-dev", "wget", "libapache2-mod-passenger",
           "ruby-bundler", "rake" ]:
  ensure => installed,
  require => [ Exec["/usr/bin/apt-get update -y"] ]
}

service { "apache2":
  enable => true,
  ensure => running,
  subscribe => [ Package["apache2"] ],
}

exec { "osm_git":
  cwd => "/home/vagrant",
  user => "vagrant",
  command => "/usr/bin/git clone https://github.com/openstreetmap/openstreetmap-website.git",
  creates => "/home/vagrant/openstreetmap-website",
  require => [Package["git-core"]],
}

file { "/etc/apache2/sites-available/default" :
  owner => root,
  group => root,
  source => "/vagrant/configs/default",
  mode => 644,
  require => [Package["apache2"]],
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

exec { "Set up database":
  cwd => "/var/lib/postgresql",
  user => "postgres",
  command => "/bin/sh /vagrant/manifests/osm_database.sh",
  creates => "/var/lib/postgresql/database_setup.log",
  logoutput => "true",
  require => [ Package["postgresql-contrib"] ]
}

exec { "bundle":
  cwd => "/home/vagrant/openstreetmap-website",
  user => "vagrant",
  command => "sudo bundle install && touch /home/vagrant/bundle.log",
  creates => "/home/vagrant/bundle.log",
  logoutput => "true",
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin"], 
  require => [Exec["osm_git"]]
} 

exec { "rake_migrate":
  cwd => "/home/vagrant/openstreetmap-website",
  user => "vagrant",
  command => "rake db:migrate && touch /home/vagrant/rake_migrate.log",
  creates => "/home/vagrant/rake_migrate.log",
  logoutput => "true",
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin"], 
  require => [Exec["bundle"], File["/home/vagrant/openstreetmap-website/config/application.yml"], Exec["Set up database"]]
}

exec { "set_up_osm_website_directories":
  cwd => "/home/vagrant",
  user => "vagrant",
  command => "/bin/sh /vagrant/manifests/osm_directories_setup.sh && touch /home/vagrant/osm_directories_setup.log",
  creates => "/home/vagrant/osm_directories_setup.log",
  logoutput => "true",
  require => [ Exec["rake_migrate"] ]
}
