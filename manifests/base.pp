 group { "puppet":
   ensure => "present",
 }

 File { owner => 0, group => 0, mode => 0644 }

 file { '/etc/motd':
   content => "Welcome to your OpenStreetMap Dev Box v0.!"
 }

user { "vagrant":
  ensure     => "present",
  managehome => true,
}

Exec["/usr/bin/yum update -y"] -> Package <| |>

# memcached build dies for some reason without this 
file { '/usr/bin/ruby':
      ensure => link,
      target => '/opt/ruby/bin/ruby',
    }

file { '/usr/bin/gem':
      ensure => link,
      target => '/opt/ruby/bin/gem',
    }

file { '/usr/bin/passenger-install-apache2-module':
      ensure => link,
      target => '/opt/ruby/bin/passenger-install-apache2-module',
    }

file { '/usr/bin/bundle':
      ensure => link,
      target => '/opt/ruby/bin/bundle',
    }

file { '/usr/bin/rake':
      ensure => link,
      target => '/opt/ruby/bin/rake',
    }

file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL":
     owner => root,
     group => root,
     source => "/vagrant/configs/RPM-GPG-KEY-EPEL",
}

file { "/etc/yum.repos.d/epel.repo":
   owner => root,
   group => root,
   source => "/vagrant/configs/epel.repo",
   mode => 644,
   require => File["/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL"]
}


exec { "/usr/bin/yum update -y":
  user => "root",
  timeout => 3600,
  require => File['/etc/yum.repos.d/epel.repo'],
}




 package { "vim-minimal":
  ensure => installed,
 }

package { "postgresql84":
  ensure => installed,
}

package { "postgresql84-devel":
  ensure => installed,
}


package { "postgresql84-contrib":
  ensure => installed,
}


package { "postgresql84-server":
  ensure => installed,
}

exec { "/usr/bin/initdb /var/lib/pgsql/data":
  cwd => "/var/lib/pgsql",
  user => "postgres",
  command => "/usr/bin/initdb /var/lib/pgsql/data",
  creates => "/var/lib/pgsql/data/PG_VERSION",
  logoutput => "true",
  require => [Package["postgresql84-server"]]
}   

service { "postgresql":
    enable => true,
    ensure => running,
    subscribe => [ Exec["/usr/bin/initdb /var/lib/pgsql/data"] ],
}


package { "perl":
  ensure => installed,
}



# package { "ruby":
#  ensure => installed,
# }

package { "git":
  ensure => installed,
}

 package { "libxml2-devel":
 ensure => installed,
 }

 package { "libxslt-devel":
 ensure => installed,
 }

# package { "ruby-dev":
# ensure => installed,
# }

 package { "httpd-devel":
 ensure => installed,
 }

 package { "ImageMagick":
  ensure => installed,
 }


 package { "ImageMagick-devel":
 ensure => installed,
 }



#package { "libopenssl-ruby":
# ensure => installed,
# }

package { "subversion":
 ensure => installed,
 }

package { "httpd":
 ensure => installed,
 }

package { "curl-devel":
  ensure => installed,
}

package { "expect":
  ensure => installed,
}

package { "expect-devel":
  ensure => installed,
}

package { "cyrus-sasl-devel":
  ensure => installed,
}

package { "wget" :
  ensure => installed,
}


service { "httpd":
    enable => true,
    ensure => running,
    subscribe => [ Package["httpd"] ],
}



exec { "osm_git":
  cwd => "/home/vagrant",
  user => "vagrant",
  command => "/usr/bin/git clone git://github.com/openstreetmap/openstreetmap-website.git",
  creates => "/home/vagrant/openstreetmap-website",
  require => [Package["git"]],
} 


file { "/etc/httpd/conf.d/passenger" :
   owner => root,
   group => root,
   source => "/vagrant/configs/passenger",
   mode => 644,
   require => [Package["httpd"]],
}

#file { "/etc/apache2/sites-available/default" :
#   owner => root,
#   group => root,
#   source => "/vagrant/configs/default",
#   mode => 644,
#   require => [Package["httpd"]],
#}


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
  cwd => "/var/lib/pgsql",
  user => "postgres",
  command => "/bin/sh /vagrant/manifests/osm_database.sh",
  creates => "/var/lib/pgsql/database_setup.log",
  logoutput => "true",
  require => Service["postgresql"]
} 




exec { "passenger":
  cwd => "/home/vagrant",
  user => "vagrant",
  command => "sudo gem install passenger --no-ri --no-rdoc && touch /home/vagrant/passenger.log",
  creates => "/home/vagrant/passenger.log",
  logoutput => "true",
  timeout => 3600,
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
  timeout => 3600, 
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




