include logrotate

logrotate_app node['appserver']['log_name'] do
  cookbook 'logrotate'
  path node['appserver']['log_paths']
  frequency 'daily'
  create '644 root adm'
  rotate 7
end