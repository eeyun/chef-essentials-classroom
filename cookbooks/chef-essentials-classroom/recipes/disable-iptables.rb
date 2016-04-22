#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: disable-iptables
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
case node[:platform_family]
when 'rhel'
  service 'iptables' do
    action [:stop, :disable]
  end
when 'debian'
  execute 'ufw disable' do
    command 'ufw disable && touch /tmp/ufw_disabled'
    not_if {::File.exists?('/tmp/ufw_disabled')}
  end
end
