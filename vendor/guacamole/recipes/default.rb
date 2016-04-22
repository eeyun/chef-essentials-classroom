#
# Cookbook Name:: guacamole
# Recipe:: default
#
# Copyright (c) 2015 Matt Stratton, Licensed under the Apache License, Version 2.0

include_recipe 'apt'
# Install package dependencies

# Core dependencies

%w(gcc g++ libcairo2-dev libpng-dev uuid-dev libjpeg-dev libossp-uuid-dev ).each do |package|
  package package do
    action :install
  end
end

# Optional dependencies

%w(freerdp-x11 libpango1.0-dev libssh2-1-dev libssl-dev ).each do |package|
  package package do
    action :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/guacamole-server-#{node['guacamole']['version']}.tar.gz" do
  source "https://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-#{node['guacamole']['version']}.tar.gz"
  mode '0644'
  action :create_if_missing
end

bash 'build-and-install-guacamole' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    tar -xzf guacamole-server-#{node['guacamole']['version']}.tar.gz
    cd guacamole-server-#{node['guacamole']['version']} && ./configure --with-init-dir=/etc/init.d
    make && make install
    touch completed
    ldconfig
  EOF
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/guacamole-server-#{node['guacamole']['version']}/completed") }
end

service 'guacd' do
  supports :restart => true, :reload => true
  action [:enable, :start]
end

# This is where we configure the guacamole-client. May need to refactor into a separate recipe later
node.default['java']['jdk_version'] = '7'
include_recipe 'java::default'

node.default['tomcat']['home'] = '/home/tomcat_guacamole'

tomcat_install 'guacamole' do
  version '8.0.32'
  install_path '/var/lib/tomcat'
end

directory '/etc/guacamole'

directory "#{node['tomcat']['home']}/.guacamole" do
  recursive true
  user 'tomcat_guacamole'
  group 'tomcat_guacamole'
end

remote_file '/var/lib/tomcat/webapps/guacamole.war' do
  source "http://iweb.dl.sourceforge.net/project/guacamole/current/binary/guacamole-#{node['guacamole']['version']}.war"
  mode '0644'
  action :create_if_missing
end

template '/etc/guacamole/guacamole.properties' do
  source 'guacamole.properties.erb'
  mode '0644'
  notifies :restart, 'tomcat_service[guacamole]'
end

template '/etc/guacamole/user-mapping.xml' do
  source 'user-mapping.xml.erb'
  variables({:usermap => node['guacamole']['usermap']})
  mode '0644'
  notifies :restart, 'tomcat_service[guacamole]'
end

directory '/home/tomcat_guacamole' do
  user 'tomcat_guacamole'
  group 'tomcat_guacamole'
  action :create
end

link "#{node['tomcat']['home']}/.guacamole/guacamole.properties" do
  to '/etc/guacamole/guacamole.properties'
end

tomcat_service 'guacamole' do
  action [:nothing, :enable]
end

# nginx stuff
package 'nginx'
