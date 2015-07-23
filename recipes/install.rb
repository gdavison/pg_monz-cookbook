#
# Cookbook Name:: pg_monz
# Recipe:: install
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

remote_file "#{Chef::Config[:file_cache_path]}/pg_monz.tar.gz" do
  source   "https://github.com/pg-monz/pg_monz/archive/#{node['pg_monz']['version']}.tar.gz"
  checksum node['pg_monz']['sha256']
end

expand_destination = 'pg_monz'
bash 'expand' do
  code "rm --force --recursive #{expand_destination} && mkdir #{expand_destination} && tar -xvf pg_monz.tar.gz --directory #{Chef::Config[:file_cache_path]}/#{expand_destination}/ --strip-components=1"
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
