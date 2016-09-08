# -*- mode: ruby -*-
# vi: set ft=ruby :

#Define values for psuedo Chef Stack
server_types = [
    {:name => 'demo-db-server', :count => 1, :memory => 512, :cpu => 1, :chef_role => 'role[db-mysql]', :port => 9501},
    {:name => 'demo-app-server', :count => 1, :memory => 512, :cpu => 1, :chef_role => 'role[app-tomcat]', :port => 9502},
    {:name => 'demo-lb-server', :count => 1, :memory => 512, :cpu => 1, :chef_role => 'role[lb-haproxy]', :port => 9503}
]

VAGRANTFILE_API_VERSION = '2'

provider_type = ENV['provider_type'].to_s.empty? ? 'vb' : ENV['provider_type']
deploy_type = ENV['deploy_type'].to_s.empty? ? 'chef_zero' : ENV['deploy_type']
box_type = ENV['box_type'].to_s.empty? ? 'opscode' : ENV['box_type']

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  server_types.each do |server_type|
    (1..server_type[:count]).each do |i|
      config.vm.define "#{provider_type}-#{server_type[:name]}-#{i}" do |server|
        hostname = "#{provider_type}-#{server_type[:name]}-#{i}"

        case box_type
          when 'opscode'
            server.vm.box = 'opscode-centos-7.1'
            server.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.1_chef-provisionerless.box'
          else
            # Alternatively use from Atlas at HashiCorp
            server.vm.box = 'centos-7.1'
            server.vm.box_url = 'bento/centos-7.1'
        end
        server.vm.hostname = hostname

        # Skip checking for an updated Vagrant box
        server.vm.box_check_update = false

        case deploy_type
          when 'chef_client'
            config.berkshelf.enabled = true
            config.vm.provision :chef_client do |chef|
              chef.chef_server_url = 'https://chefserver.rwhitney.com/organizations/rb1whitney'
              chef.validation_client_name = 'rwhitney'
              chef.node_name = hostname
              chef.validation_key_path = '/etc/chef/rb1whitney.pem'
              chef.run_list = [server_type[:chef_role]]
              chef.log_level = 'info'
              chef.environment = 'local'
              chef.delete_node = true
              chef.delete_client = true
            end
          else
            config.omnibus.chef_version = :latest
            config.vm.provision :chef_zero do |chef_zero|
              chef_zero.cookbooks_path = %w( cookbooks site-cookbooks)
              chef_zero.environments_path = 'environments'
              chef_zero.data_bags_path = 'data_bags'
              chef_zero.nodes_path = 'nodes'
              chef_zero.roles_path = 'roles'
              chef_zero.run_list = [server_type[:chef_role]]
            end
        end

        case provider_type
          when 'docker'
            ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'
            server.vm.synced_folder '.', '/vagrant', disabled: true
            server.vm.network 'forwarded_port', guest: 80, host: server_type[:port]
            server.vm.network 'private_network', type: 'dhcp'

            config.vm.provider :docker do |docker|
              docker.build_dir = '.'
              docker.has_ssh = true
            end
          when 'aws'
            server.vm.synced_folder '.', '/vagrant', disabled: true

            config.vm.provider :aws do |aws|
              aws.access_key_id = ENV['AWS_ACCESS_KEY']
              aws.secret_access_key = ENV['AWS_SECRET_KEY']
              aws.keypair_name = ENV['AWS_EC2_KEY_NAME']
              aws.security_groups = ENV['AWS_SECURITY_GROUP_NAME']
              aws.ami = 'ami-4ad94c7a'
              aws.instance_type = 't1.micro'
              aws.region = 'us-west-2'
              aws.ssh_username = 'centos'
              aws.tags = {Name: 'Demo AWS Applications'}
            end
          else
            server.vm.network 'forwarded_port', guest: 80, host: server_type[:port]
            server.vm.network 'private_network', type: 'dhcp'

            server.vm.provider :virtualbox do |vb|
              vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
              vb.customize ['modifyvm', :id, '--memory', server_type[:memory]]
              vb.customize ['modifyvm', :id, '--cpus', server_type[:cpu]]
              vb.customize ['modifyvm', :id, '--name', hostname]
            end
        end
      end
    end
  end
end