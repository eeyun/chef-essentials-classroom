#
# Cookbook Name:: chef-essentials-classroom
# Recipe:: add-chef-user
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Create user 'chef' with password 'chef' for student use
user 'chef' do
  action :create
  comment 'Chef Boyardee'
  home '/home/chef'
  shell '/bin/bash'
  password 'chef'
  supports :manage_home => true
end

# Setup 'chef' users .bash_profile
template '/home/chef/.bash_profile' do
  source 'chef-bash-profile.erb'
  owner 'chef'
  group 'chef'
  mode '0644'
end

execute 'reset chef password' do
  command 'echo "chef:chef"|chpasswd && touch /tmp/pass_updated'
  not_if ::File.exist?('/tmp/pass_updated')
end

case node[:platform_family]
when 'rhel'
# Enables password authentication
  template '/etc/ssh/sshd_config' do
    source 'sshd_config.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[sshd]'
  end

  service 'sshd' do
    action :nothing
  end
when 'debian'
# Enables password authentication
  template '/etc/ssh/sshd_config' do
    source 'sshd_config.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[ssh]'
  end
  service 'ssh' do
    action :restart
  end
end

# Enables password-less sudo for user 'chef'
template '/etc/sudoers' do
  source 'sudoers.erb'
  owner 'root'
  group 'root'
  mode '0440'
end
