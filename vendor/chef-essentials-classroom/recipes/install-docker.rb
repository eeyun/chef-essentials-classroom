#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: install-docker
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'yum-epel'

package 'docker-io' do
  action :install
end

service 'docker' do
  action [:start, :enable]
end

gem_package 'kitchen-docker' do
    gem_binary '/opt/chefdk/embedded/bin/gem'
    options '--no-user-install'
    action :upgrade
end

docker_image 'centos' do
    tag 'centos6'
    action :pull
end

docker_image 'ubuntu' do
    tag '14.04'
    action :pull
end