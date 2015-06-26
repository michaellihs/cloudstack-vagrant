require 'digest/sha2'

user_password = 'password'
salt = rand(36**8).to_s(36)
shadow_hash = user_password.crypt("$6$" + salt)

user "Setting root password" do
  username 'root'
  password shadow_hash
  action :modify
end

%w(ntp nfs-utils mysql-server vim).each do |package|
  package package do
    action :install
  end
end

yum_repository 'cloudstack' do
  description 'Cloudstack Package Repository'
  baseurl 'http://cloudstack.apt-get.eu/rhel/4.5/'
  gpgcheck false
  action :create
  enabled true
end

cookbook_file '/etc/exports' do
  source 'exports'
  user 'root'
  group 'root'
  mode '0644'
end

directory '/primary' do
  action :create
  user 'root'
  group 'root'
  mode '0755'
end

directory '/secondary' do
  action :create
  user 'root'
  group 'root'
  mode '0755'
end

cookbook_file '/etc/sysconfig/nfs' do
  source 'nfs'
  user 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/etc/my.cnf' do
  source 'my.cnf'
  user 'root'
  group 'root'
  mode '0644'
end

%w(mysqld rpcbind nfs).each do |service_name|
  service service_name do
    action [ :enable, :start ]
  end
end

# TODO For some reason, this results in `yum -d0 -e0 -y install cloudstack-management-4.5.1-shapeblue0.el6` which does not seem to work
# package 'cloudstack-management' do
#   action :install
# end

execute 'Install cloudstack-management package via yum' do
  command 'sudo yum --enablerepo=updates clean metadata && sudo yum -y install cloudstack-management'
end

execute 'Setup CloudStack databases' do
  command 'sudo cloudstack-setup-databases cloud:cloud@localhost --deploy-as=root'
end

execute 'cloudstack-setup-management' do
  command 'sudo cloudstack-setup-management'
end

service 'cloudstack-management' do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

execute 'Import System VM for CloudStack' do
  command '/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt -m /secondary -u http://cloudstack.apt-get.eu/systemvm/4.5/systemvm64template-4.5-kvm.qcow2.bz2 -h kvm -F'
end


