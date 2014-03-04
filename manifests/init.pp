$proj_name = "my_project"
group { 'puppet': ensure => present }
Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ] }
File { owner => 0, group => 0, mode => 0644 }

class {'apt':
  always_apt_update => true,
}

package { [
    'build-essential',
    'vim',
    'curl',
    'git-core',
    'libpq-dev',
    'python-imaging',
    'libevent-dev',
  ]:
  ensure  => 'installed',
} ->
class { '::rabbitmq':
} ->

# PostgreSQL
class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => '*',
    ipv4acls                   => ['host all all 0.0.0.0/0 md5'],
    manage_firewall     => true,
    postgres_password          => 'postgres',
} ->
postgresql::server::db { "${proj_name}db":
  user     => "${proj_name}_u",
  password => "${proj_name}_u",
  encoding => "UTF-8"
} ->


# Python
class { 'python':
  version    => 'system',
  pip        => true,
  dev        => true,
  virtualenv => true,
  gunicorn   => false,
} ->

#venv
python::virtualenv { "/home/vagrant/.venvs/${proj_name}":
  ensure       => present,
  version      => 'system',
  requirements => '/vagrant/requirements.txt',
  systempkgs   => true,
  distribute   => false,
  owner        => 'vagrant',
  group        => 'vagrant',
}
 ->
# supervisord
class { 'supervisord':
  app_name    => "${proj_name}",
  python_path        => "/home/vagrant/.venvs/${proj_name}/bin/python",
  app_path           => "/vagrant/${proj_name}",
  manage_path        => "/vagrant/manage.py",
  user               => 'vagrant',
  venv_path          => "/home/vagrant/.venvs/${proj_name}",
  django_settings_module => "${proj_name}.settings",
  django_wsgi_module => "${proj_name}.wsgi"
}
->

exec { 'collect_statics':
    cwd     =>'/vagrant/',
    user   => 'vagrant',
    command => "/home/vagrant/.venvs/${proj_name}/bin/python /vagrant/manage.py collectstatic --noinput",
    logoutput => false,
}->

exec { 'syncdb':
    cwd     =>'/vagrant/',
    user   => 'vagrant',
    command => "/home/vagrant/.venvs/${proj_name}/bin/python /vagrant/manage.py syncdb --noinput",
    logoutput => true,
}->
#nginx
class {'nginx':

  upstream_name      => "${proj_name}_upstream",
  upstream_server    => 'unix:/tmp/gunicorn.sock',

  server_name      => "${proj_name}.org",
  access_log      => "/var/log/nginx/${proj_name}_acess.log",
  error_log      => "/var/log/nginx/${proj_name}_acess.log",

  app_path      => "/vagrant/${proj_name}",
}

