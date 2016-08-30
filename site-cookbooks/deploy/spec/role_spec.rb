require 'chefspec'
require 'chefspec/berkshelf'

describe 'Role Recipes' do

  let(:lb_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04').converge('role[lb-haproxy]') }
  let(:app_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04').converge('role[app-tomcat]') }
  let(:db_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04').converge('role[db-mysql]') }

  it 'should have right load balancer recipes' do

    expect(lb_run).to include_recipe('haproxy')
    expect(lb_run).to include_recipe('apt')
  end

  it 'should set required load balancer values' do
    expect(lb_run.node['server_affix']).to eq('lb-server')
    expect(lb_run.node['haproxy']['app_server_role']).to eq('app-tomcat')
    expect(lb_run.node['haproxy']['balance_algorithm']).to eq('roundrobin')
  end

  it 'should have right app server recipes' do
    expect(app_run).to include_recipe('my-tomcat::tomcat_app')
    expect(app_run).to include_recipe('my-tomcat::logrotate')
    expect(app_run).to include_recipe('apt')
  end

  it 'should set required app server values' do
    expect(app_run.node['server_affix']).to eq('app-server')
    expect(app_run.node['java']['jdk_version']).to eq('7')
    expect(app_run.node['tomcat']['base_version']).to eq('7')
  end

  it 'should have right db recipes' do
    expect(db_run).to include_recipe('apt')
  end

  it 'should set required app server values' do
    expect(db_run.node['server_affix']).to eq('db-server')
  end
end