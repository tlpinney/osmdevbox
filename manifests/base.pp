 group { "puppet":
   ensure => "present",
 }

 File { owner => 0, group => 0, mode => 0644 }

 file { '/etc/motd':
   content => "Welcome to your OpenStreetMap Dev Box v0.1!"
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





exec { "Create puppet Git repo":
  cwd => "/home/vagrant",
  user => "vagrant",
  command => "/usr/bin/git clone https://github.com/openstreetmap/openstreetmap-website.git",
  creates => "/home/vagrant/openstreetmap-website",
  require => [Package["git-core"]],
} 
