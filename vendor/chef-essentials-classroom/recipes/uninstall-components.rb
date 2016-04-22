#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: uninstall-components
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Remove these packages as we will instruct students to install them via Chef
remove_packages = ['git', 'tree', 'cowsay']

remove_packages.each do |pkg|
    package pkg do
      action :remove
    end
end