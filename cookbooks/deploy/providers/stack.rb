require 'chef/provisioning'

action :create do
  environments = search(:environment, "name:#{new_resource.environment_name}")
  Chef::Log.fatal "Unable to find any environment searching for: #{new_resource.environment_name}." if environments.empty?
  environment_name = environments.first.name
  environment_attributes = environments.first.default_attributes

  #Creates all role servers in the order passed
  new_resource.stacks.each { |roles_to_create|
    machine_batch roles_to_create do
      roles_to_create.each { |role_to_create|
        roles = search(:role, "name:#{role_to_create}")
        Chef::Log.fatal "Unable to find any roles searching for: #{new_resource.role_name}." if roles.empty?
        role_name = roles.first.name
        role_attributes = roles.first.default_attributes
        (1..environment_attributes['deploy']['servers'][role_name]['count']).each { |i|
          machine "#{environment_name}-#{role_attributes['server_affix']}-#{i}" do
            role role_name
            chef_environment environment_name
            machine_options :docker_options => role_attributes['docker_options']
          end
        }
      }
    end
  }
end

action :destroy do
  #Destroys all servers together
  machine_batch do
    new_resource.stacks.each { |roles_to_delete|
      roles_to_delete.each { |role_to_delete|
        servers = search(:node, "chef_environment:#{new_resource.environment_name} AND roles:#{role_to_delete}")
        servers.each { |server|
          machine server['name'] do
            action :destroy
          end
        }
      }
    }
  end
end