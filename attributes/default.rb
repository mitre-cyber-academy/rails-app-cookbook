require "securerandom"

default["rails-app"]["name"] = "default"
default["rails-app"]["address"] = node['fqdn'] || node["rails-app"]["name"] # Only required for ssl sites anyway.
default["rails-app"]["action"] = :deploy
default["rails-app"]["path"] = "/opt/#{node["rails-app"]["name"]}"
default["rails-app"]["deploy_key"] = nil
default["rails-app"]["repository"] = nil
default["rails-app"]["revision"] = "master"
default["rails-app"]["environment"] = "production"
default["rails-app"]["db_host"] = "127.0.0.1"
default["rails-app"]["db_adapter"] = "postgresql"
default["rails-app"]["db_name"] = "rails-app-#{default["rails-app"]["name"]}"
default["rails-app"]["db_username"] = "postgres"
default["rails-app"]["db_password"] = node["rails-app"]["db_password"] || ::SecureRandom.base64(24)
default['rails-app']['db_port'] = node['postgresql']['config']['port']
default["rails-app"]["bundler"] = true
default["rails-app"]["bundle_command"] = "bundle"
default["rails-app"]["bundler_deployment"] = true
default["rails-app"]["migrate"] = true
default["rails-app"]["gems"] = []
default["rails-app"]["bundler_without_groups"] = []
default["rails-app"]["ssl"] = false
default["rails-app"]["ruby-version"] = "2.2" # Ruby version from brightbox
default["rails-app"]["precompile_assets"] = true
default["rails-app"]["delete_before_bundle"] = [".rbenv-version", ".ruby-version"]
normal['postgresql']['password']['postgres'] = node["rails-app"]["db_password"]
normal['apt']['compile_time_update'] = true
normal['authorization']['sudo']['include_sudoers_d'] = true
normal['build-essential']['compile_time'] = true
normal["databox"]["databases"]["postgresql"] = [
  {
    "database_name" => node["rails-app"]["db_name"],
    "username" => node["rails-app"]["db_username"],
    "password" => node["rails-app"]["db_password"]
  }
]
normal['nginx']['install_method'] = "package"
normal['nginx']['repo_source'] = "passenger"
normal['nginx']['package_name'] = "nginx-extras"
override['postgresql']['pg_hba'] = [
  {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
  {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'trust'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'trust'}
]