require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/home/zabbix/') do
  it { should be_directory                  }
  it { should be_mode 755              }
  it { should be_owned_by 'zabbix'     }
  it { should be_grouped_into 'zabbix' }
end

describe file('/home/zabbix/.pgpass') do
  it { should be_file                  }
  it { should be_mode 600              }
  it { should be_owned_by 'zabbix'     }
  it { should be_grouped_into 'zabbix' }
  context 'populating the .pgpass file' do
    let(:hostname) { '127.0.0.1' }
    let(:port    ) { '5432'      }
    let(:database) { '*'         }
    let(:username) { 'postgres'  }
    let(:password) { 'password'  }
    its(:content ) { should match /^#{Regexp.quote("#{hostname}:#{port}:#{database}:#{username}:#{password}")}$/ }
  end
end
