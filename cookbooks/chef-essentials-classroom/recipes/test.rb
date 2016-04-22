template 'user-mapping.tmpl' do
  path '/etc/confd/templates/user-mapping.xml.tmpl'
  source 'user-mapping.xml.tmpl.erb'
  mode '0644'
  notifies :restart, 'confd_service[confd]', :immediately
  notifies :restart, 'tomcat_service[guacamole]'
  action :nothing
end
