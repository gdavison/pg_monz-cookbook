#
# Cookbook Name:: pg_monz-cookbook
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "#{Chef::Config[:file_cache_path]}/pg_monz.tar.gz" do
  source   "https://github.com/pg-monz/pg_monz/archive/#{node['pg_monz']['version']}.tar.gz"
  checksum node['pg_monz']['sha256']
end

bash 'expand' do
  code "tar -xvf pg_monz.tar.gz -C #{Chef::Config[:file_cache_path]}/pg_monz/"
  cwd  Chef::Config[:file_cache_path]
end

bash 'install user parameter config' do
  code  "cp #{Chef::Config[:file_cache_path]}/pg_monz/pg_monz/userparameter_pgsql.conf #{node['zabbix']['agent']['include_dir']}/"
end