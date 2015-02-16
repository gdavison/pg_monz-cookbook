#
# Cookbook Name:: pg_monz-cookbook
# Recipe:: zabbix_user
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'postgresql::server'

# reload the passwd file to make sure we have any added users
ohai 'reload_passwd' do
  action :reload
  plugin 'etc'
end

user = node['zabbix']['agent']['user']
home = node['etc']['passwd']['zabbix']['dir']
template "#{home}/.pgpass" do
  source 'pgpass.erb'
  mode   '0600'
  action :create
end
