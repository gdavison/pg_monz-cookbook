#
# Cookbook Name:: pg_monz-cookbook
# Recipe:: install
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'zabbix-agent::default'

remote_file "#{Chef::Config[:file_cache_path]}/pg_monz.tar.gz" do
  source   "https://github.com/pg-monz/pg_monz/archive/#{node['pg_monz']['version']}.tar.gz"
  checksum node['pg_monz']['sha256']
end

expand_destination = 'pg_monz'
bash 'expand' do
  code "mkdir #{expand_destination} && tar -xvf pg_monz.tar.gz --directory #{Chef::Config[:file_cache_path]}/#{expand_destination}/ --strip-components=1"
  cwd  Chef::Config[:file_cache_path]
end

file 'install user parameter config' do
  path     "#{node['zabbix']['agent']['include_dir']}/userparameter_pgsql.conf"
  owner    node['zabbix']['agent']['user']
  group    node['zabbix']['agent']['group']
  mode     '644'
  content  lazy { ::File.open("#{Chef::Config[:file_cache_path]}/#{expand_destination}/pg_monz/userparameter_pgsql.conf").read }
  notifies :restart, 'service[zabbix-agent]'
end

['find_dbname.sh', 'find_dbname_table.sh'].each do |script_name|
  file "install #{script_name}" do
    path     "/usr/local/bin/#{script_name}"
    owner    node['zabbix']['agent']['user']
    group    node['zabbix']['agent']['group']
    mode     '755'
    content  lazy { ::File.open("#{Chef::Config[:file_cache_path]}/#{expand_destination}/pg_monz/#{script_name}").read }
    notifies :restart, 'service[zabbix-agent]'
  end
end
