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