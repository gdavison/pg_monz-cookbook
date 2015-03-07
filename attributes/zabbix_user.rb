default['pg_monz']['hostname']      = '127.0.0.1'
default['pg_monz']['postgres_port'] = node['postgresql']['config']['port']
default['pg_monz']['database']      = '*'
default['pg_monz']['username']      = 'postgres'
default['pg_monz']['password']      = node['postgresql']['password'][node['pg_monz']['username']]
