require 'chef/provisioning'

action :create do
  environments = search(:environment, "name:#{new_resource.environment_name}")
  Chef::Log.fatal "Unable to find any environment searching for: #{new_resource.environment_name}." if environments.empty?
  target_environment = environments.first.name
  target_attributes = environments.first.default_attributes
  with_driver 'vagrant' do
    #Creates all role servers in the order passed
    new_resource.stacks.each { |roles_to_create|
      machine_batch roles_to_create do
        roles_to_create.each { |role_to_create|
          roles = search(:role, "name:#{role_to_create}")
          Chef::Log.fatal "Unable to find any roles searching for: #{new_resource.role_name}." if roles.empty?
          role_name = roles.first.name
          role_attributes = roles.first.default_attributes

          vagrant_config = <<EOF
    config.vm.provider 'virtualbox' do |v|
      v.memory = #{role_attributes['memory']}
      v.cpus = #{role_attributes['cpu']}
    end
EOF
          options = {
              vagrant_options: role_attributes['vagrant_options'],
              vagrant_config: vagrant_config
          }
              # case ENV['provider']
              #         when 'docker'
              #           {
              #               docker_options: role_attributes['docker_options']
              #           }
              #         else
              #
              #       end

          (1..target_attributes['deploy']['servers'][role_name]['count']).each { |i|
            machine "#{target_environment}-#{role_attributes['server_affix']}-#{i}" do
              role role_name
              chef_environment target_environment
              machine_options options
            end
          }
        }
      end
    }
  end
end

action :destroy do
  #Destroys all servers by role
  new_resource.stacks.each { |roles_to_delete|
    roles_to_delete.each { |role_to_delete|
      machine_batch role_to_delete do
        machines search(:node, "chef_environment:#{new_resource.environment_name} AND roles:#{role_to_delete}").map { |n| n.name }
        action :destroy
      end
    }
  }
end