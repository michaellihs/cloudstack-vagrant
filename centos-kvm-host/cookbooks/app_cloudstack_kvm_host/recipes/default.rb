require 'digest/sha2'

user_password = 'password'
salt = rand(36**8).to_s(36)
shadow_hash = user_password.crypt("$6$" + salt)

user "Setting root password" do
  username 'root'
  password shadow_hash
  action :modify
end

yum_repository 'cloudstack' do
  description 'Cloudstack Package Repository'
  baseurl 'http://cloudstack.apt-get.eu/rhel/4.5/'
  gpgcheck false
  action :create
  enabled true
end

# TODO this results in 'yum -d0 -e0 -y install cloudstack-agent-4.5.1-shapeblue0.el6' which does not work
# %w(cloudstack-agent vim).each do |package_name|
#   package package_name do
#     action :install
#   end
# end
execute 'Install cloudstack-agent via yum' do
  command 'sudo yum --enablerepo=updates clean metadata && sudo yum -y install cloudstack-agent'
end

network_scripts_path = '/etc/sysconfig/network-scripts/'
cloudstack_conf_path = '/etc/cloudstack/agent/'

# TODO the agent.properties might need some template variables, e.g. guuids and IP addresses
# TODO would be great if we could set the DEBUG level of the log4j configuration in attributes
# TODO we should parametrize the IP addresses of the network interfaces so that we can use this recipe to set up multiple KVM hosts
{
  'libvirtd'         => '/etc/sysconfig/libvirtd',
  'libvirtd.conf'    => '/etc/libvirt/libvirtd.conf',
  'qemu.conf'        => '/etc/libvirt/qemu.conf',
  'ifcfg-eth1.100'   => network_scripts_path + 'ifcfg-eth1.100',
  'ifcfg-eth1.200'   => network_scripts_path + 'ifcfg-eth1.200',
  'ifcfg-eth1.300'   => network_scripts_path + 'ifcfg-eth1.300',
  'ifcfg-cloudbr0'   => network_scripts_path + 'ifcfg-cloudbr0',
  'ifcfg-cloudbr1'   => network_scripts_path + 'ifcfg-cloudbr1',
  'agent.properties' => cloudstack_conf_path + 'agent.properties',
  'log4j-cloud.xml'  => cloudstack_conf_path + 'log4j-cloud.xml'
}.each do |file, path|
  cookbook_file path do
    source file
    user 'root'
    group 'root'
    mode '0644'
  end
end

service 'network' do
  action :restart
end

service 'cloudstack-agent' do
  action [ :enable, :start ]
end
