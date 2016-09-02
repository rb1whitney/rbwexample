include_recipe 'yum-mysql-community::mysql56'

mysql_service node['mysql']['name'] do
  port node['mysql']['port']
  version node['mysql']['version']
  initial_root_password node['mysql']['default_password']
  bind_address node['mysql']['bind_address']
  data_dir node['mysql']['data_dir']
  tmp_dir node['mysql']['tmp_dir']
  action [:create, :start]
end

mysql_config node['mysql']['name'] do
  source 'mysql_settings.erb'
  notifies :restart, "mysql_service[#{node['mysql']['name']}]"
  action :create
end