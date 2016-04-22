#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: create-ec2-ohai-hints
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

directory "/etc/chef/ohai/hints" do
    recursive true
end

file "/etc/chef/ohai/hints/ec2.json" do
    content '{}'
end