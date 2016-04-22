#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: build-chefdk-workstation
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'chef-essentials-classroom::yum-update'
include_recipe 'chef-essentials-classroom::set-selinux-permissive'
include_recipe 'chef-essentials-classroom::disable-iptables'
include_recipe 'chef-essentials-classroom::install-components'
include_recipe 'chef-essentials-classroom::install-etcd'
include_recipe 'chef-essentials-classroom::install-docker'
include_recipe 'chef-essentials-classroom::create-ec2-ohai-hints'
include_recipe 'chef-essentials-classroom::fix-root-volume-resize'
include_recipe 'chef-essentials-classroom::add-chef-user'
