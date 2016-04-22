#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: build-guac-server
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'chef-essentials-classroom::apt-update'
include_recipe 'chef-essentials-classroom::set-selinux-permissive'
include_recipe 'chef-essentials-classroom::disable-iptables'
include_recipe 'chef-essentials-classroom::install-etcd'
include_recipe 'chef-essentials-classroom::install-confd'
include_recipe 'chef-essentials-classroom::install-guacamole'
include_recipe 'chef-essentials-classroom::create-ec2-ohai-hints'
include_recipe 'chef-essentials-classroom::add-chef-user'
