include_recipe 'apt'
include_recipe 'logrotate'
include_recipe 'ntp'
include_recipe 'openssh'

# Install useful packages
%w( curl lsof sysstat vim ).each do |package_name|
  package package_name
end

# Enable Git Hub as valid place to install from
ssh_known_hosts_entry 'github.com'