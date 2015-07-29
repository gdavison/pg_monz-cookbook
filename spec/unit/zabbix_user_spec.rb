require 'spec_helper'

zabbix_user_home = '/ZABBIX_HOME'
hostname = 'xxx.yyy.zzz.www'
port     = 1234
database = 'DATABASE'
username = 'USERNAME'
password = 'PASSWORD'

describe 'pg_monz::zabbix_user' do
  before(:each) { stub_command('ls /recovery.conf').and_return('') }
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['etc']['passwd']['zabbix']['dir'] = zabbix_user_home
      node.set['pg_monz']['hostname']      = hostname
      node.set['pg_monz']['postgres_port'] = port
      node.set['pg_monz']['database']      = database
      node.set['pg_monz']['username']      = username
      node.set['postgresql']['password'][username]   = password
      node.set['postgresql']['password']['postgres'] = 'foobar'
      node.set['postgresql']['config']['port']       = 5432
    end.converge(described_recipe)
  end

  it 'reloads the user list' do
    expect(chef_run).to reload_ohai('reload_passwd').with(plugin: 'etc')
  end

  it 'creates the .pgpass file' do
    expect(chef_run).to create_template("#{zabbix_user_home}/.pgpass").with(mode: '0600')
  end

  context 'populating the .pgpass file' do
    it 'sets the hostname' do
      expect(chef_run).to render_file("#{zabbix_user_home}/.pgpass").with_content(/^#{hostname}:/)
    end
    it 'sets the port number' do
      expect(chef_run).to render_file("#{zabbix_user_home}/.pgpass").with_content(/^.*:#{port}:/)
    end
    it 'sets the database name' do
      expect(chef_run).to render_file("#{zabbix_user_home}/.pgpass").with_content(/^.*:.*:#{database}:/)
    end
    it 'sets the username' do
      expect(chef_run).to render_file("#{zabbix_user_home}/.pgpass").with_content(/^.*:.*:.*:#{username}:/)
    end
    it 'sets the password' do
      expect(chef_run).to render_file("#{zabbix_user_home}/.pgpass").with_content(/^.*:.*:.*:.*:#{password}$/)
    end
  end
end