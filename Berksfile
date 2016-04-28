source "https://supermarket.getchef.com"

group :community do
  cookbook 'apt'
  cookbook 'chef-dk'
  cookbook 'chef-zero'
  cookbook 'git'
  cookbook 'haproxy', '~> 1.6.7'
  cookbook 'java', '~> 1.39.0'
  cookbook 'logrotate', '~> 1.9.2'
  cookbook 'mysql', '~> 7.0.0'
  cookbook 'tomcat', '~> 2.1.0'
end

group :local do
  cookbook 'custom_recipes', path: './cookbooks/custom_recipes'
  cookbook 'deploy', path: './cookbooks/deploy'
end