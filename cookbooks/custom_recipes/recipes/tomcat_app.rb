# Install Java first
include_recipe 'java'

# Install Tomcat to the default location
tomcat_install node['tomcat']['name'] do
  version node['tomcat']['version']
end

# Deploy Custom Artifact to Tomcat
remote_file "/opt/#{node['tomcat']['name']}/webapps/sample.war" do
  owner "tomcat#{node['tomcat']['name']}"
  mode '0644'
  source 'https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war'
  checksum '89b33caa5bf4cfd235f060c396cb1a5acb2734a1366db325676f48c5f5ed92e5'
end

# Start the Tomcat Service
tomcat_service node['tomcat']['name'] do
  action [:restart, :enable]
end