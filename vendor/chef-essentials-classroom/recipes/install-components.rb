#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: install-components
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Install ChefDK
chef_ingredient "chefdk" do
    action :install
    version :latest
end

# Install Editors
editors = ['vim', 'emacs', 'nano']
editors.each do |pkg|
    package pkg do
      action :install
    end
end
