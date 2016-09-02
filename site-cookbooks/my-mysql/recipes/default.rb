mysql_service 'cloud-boot-app' do
  port '3306'
  version '5.5'
  initial_root_password 'change me'
  action [:create, :start]
end