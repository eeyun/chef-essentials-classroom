#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: install-etcd
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

etcd_service 'default' do
  action [:create,:start,:stop]
end

template '/etc/init.d/etcd' do
  source 'sysvinit/etcd.erb'
  action :create
end
