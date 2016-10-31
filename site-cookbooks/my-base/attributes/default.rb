default['deploy-app']['app_name'] = 'cloud-boot-app'


default['tomcat']['access_logs_enabled'] = false
default['tomcat']['ajp']['enabled'] = false
default['tomcat']['install_dir'] = '/usr/local/tomcat'
default['tomcat']['install_tar'] ='http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.4/bin/apache-tomcat-8.5.4.tar.gz'
default['tomcat']['manager-gui']['enabled'] = false
default['tomcat']['manager-gui']['password'] = '@*%testyfhggek2@@'
default['tomcat']['manager-gui']['username'] = 'upload-manager'
default['tomcat']['name'] = node['deploy-app']['app_name']
default['tomcat']['port'] = '9506'
default['tomcat']['user'] = "tomcat_#{node['tomcat']['name']}"
default['tomcat']['group'] = "tomcat_#{node['tomcat']['name']}"

default['tomcat']['resources']['mysql']['name'] = 'jdbc/mySqlDataSource'
default['tomcat']['resources']['mysql']['driver_class_name'] = 'com.mysql.jdbc.Driver'
default['tomcat']['resources']['mysql']['type'] = 'javax.sql.DataSource'
default['tomcat']['resources']['mysql']['username'] = 'username'
default['tomcat']['resources']['mysql']['password'] = 'password'
default['tomcat']['resources']['mysql']['url'] = 'jdbc:mysql://127.0.0.1:9507/db-mysql'

default['deploy-app']['artifact_name'] = "#{node['deploy-app']['app_name']}.war"
default['deploy-app']['endpoint_testing']['version_servlet'] = "http://localhost:#{node['tomcat']['port']}/#{node['deploy-app']['app_name']}/version"
default['deploy-app']['endpoint_testing']['welcome_servlet'] = "http://localhost:#{node['tomcat']['port']}/#{node['deploy-app']['app_name']}"
default['deploy_app']['git']['download_path'] = '/usr/local/staging'
default['deploy_app']['git']['repository'] = 'https://github.com/rb1whitney/cloud-boot-app.git'
default['deploy_app']['git']['revision'] = 'master'
default['deploy_app']['maven']['maven_args']= ''

default['logrotate']['log_name'] = 'rotate_logs'
default['logrotate']['log_paths'] = %W(/var/log/cloud-boot-app/cloud-boot-app.log #{node['tomcat']['install_dir']}/logs/catalina.out)

default['java']['jdk_version'] = '7'
default['java']['remove_deprecated_packages'] = true
default['java']['oracle']['accept_oracle_download_terms'] = true