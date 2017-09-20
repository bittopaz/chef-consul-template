include_recipe 'chef-sugar::default'

if ubuntu?
  include_recipe 'ubuntu'
elsif debian?
  include_recipe 'apt'
else
  raise 'Unsupported platform'
end

include_recipe 'ark::default'

version = node['consul-template']['version']

ark 'consul-template' do
  url "#{node['consul-template']['source_url']}/#{version}/consul-template_#{version}_linux_amd64.tgz"
  version node['consul-template']['version']
  strip_components 0
  checksum node['consul-template']['checksum']
  notifies :restart, 'service[consul-template]', :delayed
  action :install
end

directory node['consul-template']['config_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory node['consul-template']['config_template_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

file File.join(node['consul-template']['config_dir'], 'default.json') do
  owner 'root'
  group 'root'
  mode '0640'
  content JSON.pretty_generate(node['consul-template']['config'], quirks_mode: true)
  notifies :restart, 'service[consul-template]', :delayed
  action :create
end

systemd_unit 'consul-template.service' do
  content(
    'Unit' => {
      'Description' => 'Consul Template',
      'After' => 'network.target',
    },
    'Install' => {
      'WantedBy' => 'multi-user.target',
    },
    'Service' => {
      'ExecStart' => "#{node['ark']['prefix_home']}/consul-template/consul-template -config #{node['consul-template']['config_dir']}",
      'ExecReload' => '/bin/kill -HUP $MAINPID',
    })
  notifies :restart, 'service[consul-template]', :delayed
  triggers_reload true
  action [:create, :enable]
end

service 'consul-template' do
  supports status: true, restart: true, reload: true
  action :start
end
