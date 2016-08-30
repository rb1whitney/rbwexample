require 'chefspec'
require 'chefspec/berkshelf'

require 'json'

describe 'deploy::default' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(:step_into => ['deploy_stack']) do |node|
      node.set['chef_environment'] = 'spec_testing'
    end.converge(described_recipe)
  end

  before :each do
    stub_search('environment', 'name:_default').and_return([Chef::Environment.json_create(JSON.parse(File.read('environments/spec_testing.json')))])
    stub_search('role', 'name:app-tomcat').and_return([Chef::Environment.json_create(JSON.parse(File.read('roles/app-tomcat.json')))])
    stub_search('role', 'name:db-mysql').and_return([Chef::Environment.json_create(JSON.parse(File.read('roles/db-mysql.json')))])
    stub_search('role', 'name:lb-haproxy').and_return([Chef::Environment.json_create(JSON.parse(File.read('roles/lb-haproxy.json')))])
  end

  it 'should create a full stack ' do
    expect(chef_run).to converge_machine_batch('db-mysql')
    expect(chef_run).to converge_machine_batch('app-tomcat')
    expect(chef_run).to converge_machine_batch('lb-haproxy')
  end

end