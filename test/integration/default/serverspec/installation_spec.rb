require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/etc/zabbix/zabbix_agentd.d/userparameter_pgsql.conf') do
  it { should be_file                  }
  it { should be_mode 644              }
  it { should be_owned_by 'zabbix'     }
  it { should be_grouped_into 'zabbix' }
end

['/usr/local/bin/find_dbname.sh', '/usr/local/bin/find_dbname_table.sh'].each do | filename |
  describe file(filename) do
    it { should be_file                  }
    it { should be_mode 755              }
    it { should be_owned_by 'zabbix'     }
    it { should be_grouped_into 'zabbix' }
  end
end
