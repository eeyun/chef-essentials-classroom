#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: set-selinux-permissive
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

template '/etc/selinux/config' do
  source 'selinux.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'Set SELinux to Permissive Mode' do
  command 'setenforce 0'
  action :run
  only_if 'getenforce | grep Enforcing'
end
