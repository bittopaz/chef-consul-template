include_recipe 'consul-template::default' # ~FC007

consul_template_config 'nginx' do
  templates [{
    source: ::File.join(node['consul-template']['config_dir'], 'nginx.conf.ctmpl'),
    destination: ::File.join(node['consul-template']['config_template_dir'], nginx.conf.ctmpl)
    command: 'service nginx restart'
  }]
  notifies :reload, 'service[consul-template]', :delayed
end
