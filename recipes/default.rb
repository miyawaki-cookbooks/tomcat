#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node['platform_family']
#----------------------------------------
  when "rhel", "fedora", "centos" ,"oracle"

include_recipe "java"

tomcat_user = "#{node["tomcat"]["user"]}"
tomcat_group = "#{node["tomcat"]["group"]}"
version = "#{node["tomcat"]["version"]}"
tomcat_srv_name = "tomcat"

tomcat_link = "#{node["tomcat"]["ins_dir"]}/tomcat"
cur_dir  = "#{node["tomcat"]["ins_dir"]}"

# Get tar-ball name from url.
require "uri"
uri = URI.parse("#{node["tomcat"]["download"]["url"]}")
dir, base = File.split(uri.path)

tar_file = "#{Chef::Config[:file_cache_path]}/" + base
tomcat_dir  = cur_dir + "/" + base.sub(/.tar.gz/,"")


# user&group create
group tomcat_group do
  gid 53
end

user  tomcat_user  do
  uid 53
  gid tomcat_group
  home  "/var/lib/tomcat"
  shell "/sbin/nologin"
end

# tomcat
remote_file tar_file do
  source "#{node['tomcat']['download']['url']}"
  user   tomcat_user
  group  tomcat_group
end

directory cur_dir do
  owner tomcat_user
  group tomcat_group
  mode  '0755'
  action :create
end

execute "install_tomcat" do
  cwd   cur_dir
  user  tomcat_user
  group tomcat_group
  command <<-EOH
    tar xvfz #{tar_file}
  EOH
end

link tomcat_link do
  to tomcat_dir
end

directory "#{node['tomcat']['base']}" do
  owner tomcat_user
  group tomcat_group
  mode  '0755'
  action :create
end

# make $CATALINA_BASE's sub-directory.
dir = %w(base bin conf temp work webapp_dir)
dir.each do |d|
  dd = "#{node['tomcat'][d]}"
  directory dd do
    owner tomcat_user
    group tomcat_group
    mode  '0755'
    action :create
    not_if { File.exists?(dd) }
  end
end

ruby_block "conf-subdirectory copy" do
  block do
    FileUtils.cp_r("#{node['tomcat']['home']}/conf","#{node['tomcat']['base']}",{:preserve => true})
  end
  not_if { File.exists?("#{node['tomcat']['conf']}/server.xml") }
end


# CATALINA_BASEのlogsディレクトリを作成
logs_dir = "/var/log/tomcat"
directory logs_dir do
    owner tomcat_user
    group tomcat_group
    mode  '0755'
    action :create
    not_if { File.exists?(logs_dir) }
end

link "#{node['tomcat']['base']}/logs" do
  to logs_dir
end



# startup-shell create
template "/etc/init.d/tomcat" do
  source "tomcat.erb"
  owner "root"
  group "root"
  mode  0755
end

service "tomcat" do
  supports :status => true, :restart => true, :stop => true
  action [ :enable, :start ]
end

end
# ----------------------------------------------
