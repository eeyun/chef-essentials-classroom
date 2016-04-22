#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: build-managed-node
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'chef-essentials-classroom::yum-update'
include_recipe 'chef-essentials-classroom::set-selinux-permissive'
include_recipe 'chef-essentials-classroom::disable-iptables'
include_recipe 'chef-essentials-classroom::create-ec2-ohai-hints'
include_recipe 'chef-essentials-classroom::fix-root-volume-resize'
include_recipe 'chef-essentials-classroom::add-chef-user'

# Install Editors
editors = ['vim', 'emacs', 'nano']
editors.each do |pkg|
    package pkg do
      action :install
    end
end

# Install etcd

etcd_installation 'default' do
  action :create
end
