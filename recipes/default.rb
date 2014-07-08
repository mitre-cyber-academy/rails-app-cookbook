#
# Cookbook Name:: rails-app
# Recipe:: default
#
# Copyright 2014, MITRE
#

# Fix for https://tickets.opscode.com/browse/COOK-4039
gem_package 'rake' do
  action :install
  options('--force')
end

include_recipe "apt::default"
include_recipe "build-essential::default"
include_recipe "rackbox::default"
include_recipe "databox::default"

db_adapter  =  node["rails-app"]["db_adapter"]
db_host     =  node["rails-app"]["db_host"]
db_database =  node["rails-app"]["db_name"]
db_username =  node["rails-app"]["db_username"]
db_password =  node["rails-app"]["db_password"]


application node["rails-app"]["name"] do
  action    node["rails-app"]["action"]
  path      node["rails-app"]["path"]

  if node["rails-app"]["deploy_key"]
    deploy_key node["rails-app"]["deploy_key"]
  end
  repository node["rails-app"]["repository"]
  revision   node["rails-app"]["revision"]

  environment_name node["rails-app"]["environment"]

  # useful commands
  migrate           node["rails-app"]["migrate"]
  migration_command node["rails-app"]["migration_command"]

  before_migrate do
    node["rails-app"]["delete_before_bundle"].each do |filename|
      file "#{new_resource.release_path}/#{filename}" do
        action :delete
      end
    end
  end

  rails do
    bundler                node["rails-app"]["bundler"]
    bundle_command         node["rails-app"]["bundle_command"]
    bundler_deployment     node["rails-app"]["bundler_deployment"]
    bundler_without_groups node["rails-app"]["bundler_without_groups"]
    precompile_assets      node["rails-app"]["precompile_assets"]
    gems                   node["rails-app"]["gems"] | [ "bundler" ]
    # can't put node[][] things inside the database block
    database do
      adapter  db_adapter  
      host     db_host     
      database db_database 
      username db_username 
      password db_password 
    end
  end
end

nginx_passenger_site "000-default" do
  action :delete
end

nginx_passenger_site node["rails-app"]["name"] do
  action        :create
  dir           "#{node["rails-app"]["path"]}/current"
  server        node["rails-app"]["address"]
  generate_cert true if node["rails-app"]["ssl"]
end

service "nginx" do
  action :restart
end