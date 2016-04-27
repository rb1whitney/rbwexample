actions :create, :destroy
default_action :create

#Environment to create stack in
attribute :environment_name, :kind_of => String, :default => 'local', :name_attribute => true
#Pass an array of arrays to control the timing as each role servers are created
attribute :stacks, :kind_of => Array, :default => []
