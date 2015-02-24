#
# Cookbook Name:: pg_monz-cookbook
# Recipe:: zabbix_user
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'zabbix-agent::default'

# reload the passwd file to make sure we have any added users
ohai 'reload_passwd' do
  action :reload
  plugin 'etc'
end

# ensure the zabbix has a user directory
directory 'zabbix user' do
  path  lazy { node['etc']['passwd']['zabbix']['dir'] }
  #path  zabbix_home
  owner node['zabbix']['agent']['user']
  group node['zabbix']['agent']['group']
end

template 'zabbix user .pgpass' do
  source 'pgpass.erb'
  path   lazy { "#{node['etc']['passwd']['zabbix']['dir']}/.pgpass" }
  owner  node['zabbix']['agent']['user']
  group  node['zabbix']['agent']['group']
  mode   '0600'
  action :create
end
