#
# Cookbook Name:: pg_monz
# Recipe:: zabbix_user
#
# Copyright 2015 PayByPhone Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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
