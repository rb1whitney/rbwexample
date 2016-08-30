# vi:ft=ruby:
source "https://supermarket.getchef.com"

cookbook 'apt'
cookbook 'chef-dk'
cookbook 'chef-zero'
cookbook 'git'
cookbook 'haproxy', '~> 1.6.7'
cookbook 'mysql', '~> 7.0.0'
cookbook 'java', '~> 1.39.0'
cookbook 'logrotate', '~> 1.9.2'
cookbook 'tomcat', '~> 2.1.0'

Dir.glob('./site-cookbooks/*').each do |path|
  cookbook File.basename(path), path: path
end