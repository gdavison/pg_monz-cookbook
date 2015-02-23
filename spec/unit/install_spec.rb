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
    it 'is copied into place' do
      expect(chef_run).to run_bash('install user parameter config').with(
        code: "cp #{Chef::Config[:file_cache_path]}/pg_monz/pg_monz/userparameter_pgsql.conf /etc/zabbix/zabbix_agentd.d/"
      )
    end
    let(:bash_command) { chef_run.bash('install user parameter config') }
    it 'restarts the zabbix service' do
      expect(bash_command).to notify('service[zabbix-agent]').to(:restart)
    end
  end

  ['find_dbname.sh', 'find_dbname_table.sh'].each do |script_name|
    context "the discovery script #{script_name}" do
      it 'is copied into place' do
        expect(chef_run).to run_bash("install #{script_name}").with(
          code: "cp #{Chef::Config[:file_cache_path]}/pg_monz/pg_monz/#{script_name} /usr/local/bin/"
        )
      end
      let(:bash_command) { chef_run.bash("install #{script_name}") }
      it 'restarts the zabbix service' do
        expect(bash_command).to notify('service[zabbix-agent]').to(:restart)
      end
    end
  end
end