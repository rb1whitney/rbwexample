require 'spec_helper'

describe port(9508) do
  it { should be_listening }
end

describe file('/etc/mysql-cloud-boot-app/my.cnf') do
  it { should be_file }
end

describe service('mysql-cloud-boot-app') do
  it { should be_enabled }
  it { should be_running }
end

describe command('echo \'SELECT User, Host FROM mysql.user\' | mysql -S /var/run/mysql-cloud-boot-app/mysqld.sock -P 9508 --user=root --password=password') do
  its(:stdout) { should match /root\tlocalhost/ }
end

