require 'spec_helper'

pg_monz_version = "1.0.1"

describe 'pg_monz::install' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['postgresql']['config']['port'] = 1234
    end.converge(described_recipe)
  end

  it 'downloads pg_monz to the file cache' do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/pg_monz.tar.gz").with(
      source: "https://github.com/pg-monz/pg_monz/archive/#{pg_monz_version}.tar.gz",
      checksum: "c2a75f98cce6a467351db6f30c4b7595d05752c0a9940c4c1440fe86d240bef6"
    )
  end
  
  context 'the User Parameter Config file' do
    it 'restarts the zabbix service' do
      expect(chef_run.file('install user parameter config')).to notify('service[zabbix-agent]').to(:restart)
    end
  end

  ['find_dbname.sh', 'find_dbname_table.sh'].each do |script_name|
    context "the discovery script #{script_name}" do
      it 'restarts the zabbix service' do
        expect(chef_run.file("install #{script_name}")).to notify('service[zabbix-agent]').to(:restart)
      end
    end
  end
end