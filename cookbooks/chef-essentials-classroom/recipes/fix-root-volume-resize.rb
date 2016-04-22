#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: fix-root-volume-resize
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# The official CentOS 6.x HVM AMIs are missing packages required to resize the root
# volume when an instance is created. This recipe installs the missing packages

include_recipe 'yum-epel'

package 'cloud-utils-growpart' do
  action :install
end

package 'dracut-modules-growroot' do
  action :install
  notifies :run, 'execute[rebuild-initramfs]'
end

execute 'rebuild-initramfs' do
  command 'dracut --force'
  action :nothing
end