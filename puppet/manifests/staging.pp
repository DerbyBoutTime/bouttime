class prod_fw::pre {
  Firewall {
    require => undef,
  }

  #Default firewall rules
  firewall { '000 accept all icmp':
    proto => 'icmp',
    action => 'accept',
  }

  firewall { '001 accept all to lo interface':
    proto => 'all',
    iniface => 'lo',
    action => 'accept',
  }

  firewall { '002 accept related established rules':
    proto => 'all',
    ctstate => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }
}

class prod_fw::post {
  firewall { '998 allow ssh access':
    port => 22,
    proto => ['tcp', 'udp'],
    action => 'accept',
    before => undef,
  }
  firewall { '999 drop all':
    proto => 'all',
    action => 'drop',
    before => undef,
  }
}

node default {
  include git
  include postgresql::server

  resources { "firewall":
    purge => true
  }

  Firewall {
    before => Class['prod_fw::post'],
    require => Class['prod_fw::pre'],
  }

  class { ['prod_fw::pre', 'prod_fw::post']: }

  class { 'firewall': }

  firewall { '100 allow http and https access':
    port => [80, 443],
    proto => 'tcp',
    action => 'accept',
  }

  package { 'build-essential':
    ensure => "installed",
  }

  package { 'libpq-dev':
    ensure => "installed",
  }

  class { 'java' : }

  class { 'elasticsearch':
    package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.3.deb',
    require => Package['java']
  }

  # Create DB
  # postgresql::server::db { 'DB_NAME' :
  #   user => 'DB_USER',
  #   password =>'DB_PG_PASSWORD'
  # }

  class { 'nginx': }

  # Nginx proxy
  #
  # nginx::resource::upstream { 'APP_NAME':
  #   members => [
  #     'localhost:3000'
  #   ],
  # }
  #
  #nginx::resource::vhost { 'example.com':
  #  proxy => 'http://APP_NAME',
  #}

  user { 'deploy':
    ensure => "present",
    managehome => "true",
    shell => "/bin/bash"
  }

  # Authorize deploy key
  #
  # ssh_authorized_key { 'deploy key':
  #   name => 'key_name',
  #   ensure => 'present',
  #   key => 'PUBLIC KEY',
  #   type => 'ssh-rsa',
  #   user => 'deploy',
  #   require => User['deploy']
  # }

  class { 'rbenv': }
  rbenv::plugin { 'sstephenson/ruby-build': }
  rbenv::build { '2.1.3': global => true }
}