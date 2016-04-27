environment_name = ENV['env_name'] || node.chef_environment
Chef::Log.fatal "Please pass environment variables: #{environment_name}." if environment_name.to_s.empty?

deploy_stack environment_name do
  stacks [['db-mysql'], ['app-tomcat'], ['lb-haproxy']]
end