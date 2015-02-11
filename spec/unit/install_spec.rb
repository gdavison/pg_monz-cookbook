require 'spec_helper'

pg_monz_version = "1.0.1"

describe 'pg_monz::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'downloads pg_monz to the file cache' do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/pg_monz.tar.gz").with(
      source: "https://github.com/pg-monz/pg_monz/archive/#{pg_monz_version}.tar.gz",
      checksum: "c2a75f98cce6a467351db6f30c4b7595d05752c0a9940c4c1440fe86d240bef6"
    )
  end
  
  it 'extracts the package from the file cache' do
    expect(chef_run).to run_bash('expand').with(
      code: "tar -xvf pg_monz.tar.gz -C #{Chef::Config[:file_cache_path]}/pg_monz/",
      cwd:  Chef::Config[:file_cache_path]
    )
  end

  it 'copies the User Parameter Config file into place' do
    expect(chef_run).to run_bash('install user parameter config').with(
      code: "cp #{Chef::Config[:file_cache_path]}/pg_monz/pg_monz/userparameter_pgsql.conf /etc/zabbix/zabbix_agentd.d/"
    )
  end
end