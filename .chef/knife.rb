encrypted_data_bag_secret ENV['data_bag_secret'] || '/etc/chef/encrypted_data_bag_secret'

log_level                :info
log_location             STDOUT

knife[:berkshelf_path] = 'cookbooks'
knife[:editor] = 'vim -f'

ssl_verify_mode :verify_none
verify_api_cert true

chef_server_url  'https://chefserver.rwhitney.com/organizations/rb1whitney'
no_proxy 'var/run/docker.sock,localhost,127.0.0.1'
client_key '/etc/chef/rb1whitney.pem'
node_name 'rwhitney'

unless ENV['ignore_chef_path']
cookbook_path    'cookbooks'
node_path        'nodes'
role_path        'roles'
environment_path 'environments'
data_bag_path    'data_bags'
end