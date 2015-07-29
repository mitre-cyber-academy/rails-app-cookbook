name             'rails-app'
maintainer       'Robert Clark'
maintainer_email 'rbclark@mitre.org'
license          'Apache 2.0'
description      'Installs/Configures rails-app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends          'application'
depends          'application_ruby'
depends          'apt'
depends          'build-essential'
depends          'database'
depends          'nginx'
depends          'nginx_passenger'
depends          'postgresql', '>= 3.4.20'
depends          'ssh_known_hosts'