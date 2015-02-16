#
# Cookbook Name:: pg_monz-cookbook
# Recipe:: install
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'zabbix-agent'

remote_file "#{Chef::Config[:file_cache_path]}/pg_monz.tar.gz" do
  source   "https://github.com/pg-monz/pg_monz/archive/#{node['pg_monz']['version']}.tar.gz"
  checksum node['pg_monz']['sha256']
end

bash 'expand' do
  code "tar -xvf pg_monz.tar.gz -C #{Chef::Config[:file_cache_path]}/pg_monz/"
  cwd  Chef::Config[:file_cache_path]
end

bash 'install user parameter config' do
  code     "cp #{Chef::Config[:file_cache_path]}/pg_monz/pg_monz/userparameter_pgsql.conf #{node['zabbix']['agent']['include_dir']}/"
  notifies :restart, 'service[zabbix-agent]'
end

['find_dbname.sh', 'find_dbname_table.sh'].each do |script_name|
  bash "install #{script_name}" do
    code     "cp #{Chef::Config[:file_cache_path]}/pg_monz/pg_monz/#{script_name} /usr/local/bin/"
    notifies :restart, 'service[zabbix-agent]'
  end
end
