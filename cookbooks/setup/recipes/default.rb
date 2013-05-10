cookbook_file "/etc/sudoers.d/sudoers" do
  source "sudoers"
  mode 0440
  owner "root"
  group "root"
end

user node[:setup][:username] do
  gid "sudo"
  home node[:setup][:home_dir]
  shell "/bin/bash"
  password node[:setup][:password]
  supports  :manage_home => true
end

directory "#{node[:setup][:home_dir]}/.ssh" do
  owner node[:setup][:username]
  mode 0700
  action :create
end

cookbook_file "#{node[:setup][:home_dir]}/.ssh/authorized_keys" do
  source "authorized_keys"
  mode 0600
  owner node[:setup][:username]
end

template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  mode 0644
  owner "root"
end

service "ssh" do
  action :restart
end

