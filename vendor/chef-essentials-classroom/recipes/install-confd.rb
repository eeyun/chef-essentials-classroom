# Install confd

node.default['confd']['config']['nodes'] = 'http://127.0.0.1:4001'
node.default['confd']['config']['backend'] = 'etcd'
node.default['confd']['config']['interval'] = 10
node.default['confd']['config']['onetime'] = false
include_recipe "confd::default"
