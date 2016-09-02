# -*- mode: ruby -*-
# vi: set ft=ruby :

#Define values for psuedo Chef Stack
server_stack = [
    {:name => 'demo-db-server',  :count => 1, :memory => 512, :cpu => 1, :chef_role => 'role[db-mysql]', :port => 9501},
    {:name => 'demo-app-server', :count => 1, :memory => 512, :cpu => 1, :chef_role => 'role[app-tomcat]', :port => 9502},
    {:name => 'demo-lb-server',  :count => 1, :memory => 512, :cpu => 1, :chef_role => 'role[lb-haproxy]', :port => 9503}
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

        server.vm.box = "opscode-centos-7.1"
        server.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.1_chef-provisionerless.box"
        server.vm.hostname = hostname

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
                docker_config.build_dir  = "."
                docker_config.has_ssh    = true
            end
           config.vm.synced_folder ".", "/vagrant", disabled: true
        elsif provider == 'aws'
            config.vm.provider :aws do |aws|
                aws.access_key_id        = ENV['AWS_ACCESS_KEY']
                aws.secret_access_key    = ENV['AWS_SECRET_KEY']
                aws.keypair_name         = ENV['AWS_EC2_KEY_NAME']
                aws.security_groups      = ENV['AWS_SECURITY_GROUP_NAME']
                aws.ami                  = "ami-4ad94c7a"
                aws.instance_type        = "t1.micro"
                aws.region               = "us-west-2"
                aws.ssh_username         = "centos"
                aws.tags                 = { Name: "Demo AWS Applications" }
            end
            config.vm.synced_folder ".", "/vagrant", disabled: true
        else
            server.vm.provider :virtualbox do |vb_config|
              vb_config.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
              vb_config.customize ['modifyvm', :id, '--memory', server_type[:memory]]
              vb_config.customize ['modifyvm', :id, '--cpus', server_type[:cpu]]
              vb_config.customize ['modifyvm', :id, '--name', hostname]
            end
            server.vm.network "forwarded_port", guest: 80, host: server_type[:port]
            server.vm.network "public_network"
            server.vm.network "public_network", bridge: "eno16777736"
        end
      end
    end
  end
end