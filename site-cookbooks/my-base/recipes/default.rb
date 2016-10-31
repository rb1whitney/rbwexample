# Install Java and Git first
include_recipe 'java::oracle'
include_recipe 'git'
include_recipe 'maven'

# Install the Tomcat Service
tomcat_install node['tomcat']['name'] do
  tarball_uri node['tomcat']['install_tar']
  install_path node['tomcat']['install_dir']
end

# Override existing tomcat configurations
%w(tomcat-users.xml server.xml).each do |filename|
  template "#{node['tomcat']['install_dir']}/conf/#{filename}" do
    source "#{filename}.erb"
    owner node['tomcat']['user']
    group node['tomcat']['group']
    mode '0644'
    sensitive true
    notifies :restart, "tomcat_service[#{node['tomcat']['name']}]"
  end
end

tomcat_service node['tomcat']['name'] do
  action [:start, :enable]
  env_vars [{'CATALINA_PID' => "#{node['tomcat']['install_dir']}/bin/tomcat.pid"}]
  sensitive true
end

directory node['deploy_app']['git']['download_path'] do
  owner node['tomcat']['user']
  group node['tomcat']['group']
end

git node['deploy_app']['git']['download_path'] do
  repository node['deploy_app']['git']['repository']
  revision node['deploy_app']['git']['revision']
  user node['tomcat']['user']
  group node['tomcat']['group']
  action :sync
end

execute 'Deploy Tomcat with Command Line' do
  command "mvn clean package #{node['deploy_app']['maven']['maven_args']}"
  sensitive true
  cwd node['deploy_app']['git']['download_path']
  action :nothing
  subscribes :run, "git[#{node['deploy_app']['git']['download_path']}]", :immediately
end

execute 'Undeploy Tomcat Application' do
  command "rm -f #{node['tomcat']['install_dir']}/webapps/#{node['deploy-app']['artifact_name']};sleep 10"
  action :nothing
  subscribes :run, 'execute[Deploy Tomcat with Command Line]', :immediately
end

file "#{node['tomcat']['install_dir']}/webapps/#{node['deploy-app']['artifact_name']}" do
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode 0750
  content lazy { ::File.open("#{node['deploy_app']['git']['download_path']}/target/#{node['deploy-app']['artifact_name']}").read }
  action :nothing
  subscribes :create, 'execute[Undeploy Tomcat Application]', :immediately
end

node['deploy-app']['endpoint_testing'].each do |endpoint_name, endpoint_url|
  ruby_block "Checking #{endpoint_name} for connectivity" do
    block do
      require 'uri'
      require 'net/http'
      uri = URI(endpoint_url)
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        Net::HTTP::Get.new(URI.encode(endpoint_url))
      end
    end
    retries 1
    retry_delay 30
  end
end