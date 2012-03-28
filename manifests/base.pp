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

Exec["/usr/bin/apt-get update -y"] -> Package <| |>
Exec["/usr/bin/apt-get upgrade -y"] -> Package <| |>

exec { "/usr/bin/apt-get update -y":
  user => "root",
  timeout => 3600,
}

exec { "/usr/bin/apt-get upgrade -y":
  user => "root",
  timeout => 3600,
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

package { "wget" :
  ensure => installed,
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

file { "/etc/apache2/conf.d/passenger" :
  owner => root,
  group => root,
  source => "/vagrant/configs/passenger",
  mode => 644,
  require => [Package["apache2"]],
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

exec { "passenger":
  cwd => "/home/vagrant",
  user => "vagrant",
  command => "sudo gem install passenger --no-ri --no-rdoc && touch /home/vagrant/passenger.log",
  creates => "/home/vagrant/passenger.log",
  logoutput => "true",
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin"], 
  require => [File["/home/vagrant/openstreetmap-website/config/application.yml"]]
}

exec { "pfusion":
  cwd => "/home/vagrant",
  user => "vagrant",
  command => "expect /vagrant/manifests/pfusion.exp && touch /home/vagrant/pfusion.log",
  creates => "/home/vagrant/pfusion.log",
  logoutput => "true",
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin"],
  timeout => 3600,  
  require => [Exec["passenger"]]
}

exec { "bundle_gem":
  cwd => "/home/vagrant",
  user => "vagrant",
  command => "sudo gem install bundle --no-ri --no-rdoc; touch /home/vagrant/bundle_gem.log",
  creates => "/home/vagrant/bundle_gem.log",
  logoutput => "true",
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin"], 
  require => [Exec["pfusion"]]
} 

exec { "bundle":
  cwd => "/home/vagrant/openstreetmap-website",
  user => "vagrant",
  command => "sudo bundle install && touch /home/vagrant/bundle.log",
  creates => "/home/vagrant/bundle.log",
  logoutput => "true",
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin"], 
  require => [Exec["bundle_gem"]]
} 

exec { "rake_migrate":
  cwd => "/home/vagrant/openstreetmap-website",
  user => "vagrant",
  command => "rake db:migrate && touch /home/vagrant/rake_migrate.log",
  creates => "/home/vagrant/rake_migrate.log",
  logoutput => "true",
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin"], 
  require => [Exec["bundle"]]
}

exec { "set_up_osm_website_directories":
  cwd => "/home/vagrant",
  user => "vagrant",
  command => "/bin/sh /vagrant/manifests/osm_directories_setup.sh && touch /home/vagrant/osm_directories_setup.log",
  creates => "/home/vagrant/osm_directories_setup.log",
  logoutput => "true",
  require => [ Exec["rake_migrate"] ]
}