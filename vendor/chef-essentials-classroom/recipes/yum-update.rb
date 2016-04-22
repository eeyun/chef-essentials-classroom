#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: yum-update
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

execute 'Yum Update All the Things' do
  command 'yum update -y'
  action :run
  not_if { File.exists?('/root/yum-updated') }
  notifies :create, 'file[/root/yum-updated]'
end

file '/root/yum-updated' do
  action :nothing
  owner 'root'
  group 'root'
  mode '0644'
  content 'System Patched Successfully'
end