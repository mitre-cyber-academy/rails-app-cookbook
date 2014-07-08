require "securerandom"

default["rails-app"]["name"] = "default"
default["rails-app"]["address"] = node['fqdn'] # Only required for ssl sites anyway.
default["rails-app"]["action"] = :deploy
default["rails-app"]["path"] = "/opt/#{node["rails-app"]["name"]}"
default["rails-app"]["deploy_key"] = nil
default["rails-app"]["repository"] = nil
default["rails-app"]["revision"] = "master"
default["rails-app"]["environment"] = "production"
default["rails-app"]["db_host"] = "127.0.0.1"
default["rails-app"]["db_adapter"] = "postgresql"
default["rails-app"]["db_name"] = "rails-app-#{default["rails-app"]["name"]}"
default["rails-app"]["db_username"] = node["rails-app"]["name"]
default["rails-app"]["db_password"] = node["rails-app"]["db_password"] || ::SecureRandom.base64(24)
default["rails-app"]["bundler"] = true
default["rails-app"]["bundle_command"] = "#{node["rbenv"]["root_path"]}/shims/bundle"
default["rails-app"]["bundler_deployment"] = true
default["rails-app"]["migrate"] = true
default["rails-app"]["migration_command"] = "#{node["rails-app"]["bundle_command"]} exec rake db:migrate"
default["rails-app"]["gems"] = []
default["rails-app"]["bundler_without_groups"] = []
default["rails-app"]["ssl"] = false
default["rails-app"]["precompile_assets"] = true
default["rails-app"]["delete_before_bundle"] = [".rbenv-version", ".ruby-version"]

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
normal["rackbox"]["ruby"]["versions"] = %w(2.1.2)
normal["rackbox"]["ruby"]["global_version"] = node["rackbox"]["ruby"]["versions"].first
normal["databox"]["databases"]["mysql"] = false # Fix for https://github.com/teohm/databox-cookbook/pull/6
normal["databox"]["db_root_password"] = node["rails-app"]["db_password"]
normal["nginx"]["passenger"]["version"] = "4.0.45"
normal["nginx"]["passenger"]["ruby"] = "#{node["rbenv"]["root_path"]}/shims/ruby"
normal["nginx"]["passenger"]["root"] = "#{node["rbenv"]["root_path"]}/versions/#{node["rackbox"]["ruby"]["global_version"]}/lib/ruby/gems/2.1.0/gems/passenger-#{node["nginx"]["passenger"]["version"]}" # Extremely fragile to ruby version changes!
normal["nginx"]["source"]["modules"] = node["nginx"]["source"]["modules"] | ["nginx::passenger"] # Add passenger as a module to compile.
normal['nginx']['install_method'] =  "package"
override['postgresql']['pg_hba'] = [
  {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'ident'},
  {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'trust'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'trust'}
]