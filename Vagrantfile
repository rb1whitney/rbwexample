# -*- mode: ruby -*-
# vi: set ft=ruby :

# Value for Virtual Box and AWS instance at https://atlas.hashicorp.com
images = {
    :vb => {:name => 'opscode_ubuntu-12.04_provisionerless', :url => 'https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box'},
    :docker => {:name => 'opscode_ubuntu-12.04_provisionerless', :url => 'https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box'},
    :aws => {:name => 'dimroc/awsdummy'}
}
#Define values for psuedo Chef Stack
server_stack = [
    {:name => 'db-server',  :count => 1, :memory => 512, :cpu => 1, :chef_role => 'role[db-mysql]', :port => 9501},
    {:name => 'app-server', :count => 1, :memory => 512, :cpu => 1, :chef_role => 'role[app-tomcat]', :port => 9502},
    {:name => 'lb-server',  :count => 1, :memory => 512, :cpu => 1, :chef_role => 'role[lb-haproxy]', :port => 9503}
]

VAGRANTFILE_API_VERSION = '2'
#ip_address_octet = 100

provider = ENV['provider'].nil? ? 'vb' : ENV['provider']

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  server_stack.each do |server_type|
    (1..server_type[:count]).each do |i|
      config.vm.define "#{provider}-#{server_type[:name]}-#{i}" do |server|
        hostname = "#{provider}-#{server_type[:name]}-#{i}"
        #ip_address_octet = (ip_address_octet + 1)

        server.vm.box = images[:vb][:name]
        server.vm.box_url = images[:vb][:url]
        server.vm.hostname = hostname
        server.vm.network "forwarded_port", guest: 80, host: server_type[:port]
        server.vm.network "public_network"

        # Skip checking for an updated Vagrant box
        config.vm.box_check_update = false

        server.vm.provision :chef_client do |chef|
          chef.chef_server_url = 'https://chefserver.rwhitney.com/organizations/rb1whitney'
          chef.validation_client_name = 'rwhitney'
          chef.node_name = hostname
          chef.validation_key_path = '/etc/chef/rb1whitney.pem'
          chef.run_list = [server_type[:chef_role]]
          chef.log_level = 'info'
          chef.environment = 'local'
        end

        if provider == 'docker'
            ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'
            config.vm.provider :docker do |docker_config|
                docker_config.build_dir = "."
                docker_config.has_ssh = true
            end

           config.vm.synced_folder ".", "/vagrant", disabled: true
        else
            server.vm.provider :virtualbox do |vb_config|
              vb_config.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
              vb_config.customize ['modifyvm', :id, '--memory', server_type[:memory]]
              vb_config.customize ['modifyvm', :id, '--cpus', server_type[:cpu]]
              vb_config.customize ['modifyvm', :id, '--name', hostname]
            end
        end
      end
    end
  end
end