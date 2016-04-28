require 'spec_helper'

describe port(9506) do
  it { should be_listening }
end

describe port(9443) do
  it { should be_listening }
end

describe service('tomcat') do
  it { should be_running}
end