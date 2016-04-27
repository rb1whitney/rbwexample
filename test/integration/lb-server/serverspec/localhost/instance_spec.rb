require 'spec_helper'

describe port(9080) do
  it { should be_listening }
end

describe service('haproxy') do
  it { should be_enabled }
  it { should be_running}
end