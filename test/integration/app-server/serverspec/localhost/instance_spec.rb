require 'spec_helper'

describe port(9506) do
  it { should be_listening }
end

describe service('tomcat_cloud-boot-app') do
  it { should be_running }
end

describe file('/usr/local/tomcat/webapps/cloud-boot-app.war') do
  it { should exist }
end

%w(git java-1.7.0-openjdk logrotate).each do |package_name|
  describe package(package_name) do
    it { should be_installed }
  end
end