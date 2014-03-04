class supervisord (
  $app_name           = 'myapp',
  $python_path        = '',
  $manage_path        = '',
  $app_path           = '',
  $user               = '',
  $venv_path          = '',
  $django_settings_module = '',
  $django_wsgi_module = '',
) {
  # $ensure           = 'present',
  # $package_name     = $postgresql::params::server_package_name,

    file { "/etc/supervisord":
      path    => "/etc/supervisord",
      owner   => 'vagrant',
      group   => 'vagrant',
      ensure  => directory
    }
    file { "/var/log/supervisord/":
      path    => "/var/log/supervisord",
      owner   => 'vagrant',
      group   => 'vagrant',
      require => File['/etc/supervisord'],
      ensure  => directory
    }
    file { "/var/log/celeryd/":
      path    => "/var/log/celeryd/",
      owner   => 'vagrant',
      group   => 'vagrant',
      require => File['/etc/supervisord'],
      ensure  => directory
    }
    file { "/var/log/celerybeat/":
      path    => "/var/log/celerybeat/",
      owner   => 'vagrant',
      group   => 'vagrant',
      require => File['/etc/supervisord'],
      ensure  => directory
    }

    file { "/etc/supervisord/supervisord.conf":
        path    => "/etc/supervisord/supervisord.conf",
        owner   => 'vagrant',
        group   => 'vagrant',
        # mode    => '0644',
        require => File['/etc/supervisord'],
        content => template('supervisord/supervisord.conf')
    }
    file { "/etc/supervisord/conf.d":
      path    => "/etc/supervisord/conf.d",
      owner   => 'vagrant',
      group   => 'vagrant',
      ensure  => directory,
      require => File['/etc/supervisord'],
    }
    file { "/etc/supervisord/conf.d/${app_name}-celery.conf":
        path    => "/etc/supervisord/conf.d/${app_name}-celery.conf",
        owner   => 'vagrant',
        group   => 'vagrant',
        # mode    => '0644',
        require => File['/etc/supervisord/conf.d'],
        content => template('supervisord/conf.d/myapp-celery.conf')
    }
    file { "/etc/supervisord/conf.d/${app_name}-celerybeat.conf":
        path    => "/etc/supervisord/conf.d/${app_name}-celerybeat.conf",
        owner   => 'vagrant',
        group   => 'vagrant',
        require => File['/etc/supervisord/conf.d'],
        content => template('supervisord/conf.d/myapp-celerybeat.conf')
    }

    file { "/var/log/websockets/":
      path    => "/var/log/websockets/",
      owner   => 'vagrant',
      group   => 'vagrant',
      require => File['/etc/supervisord'],
      ensure  => directory
    }

    file { "/etc/supervisord/conf.d/${app_name}-websockets.conf":
        path    => "/etc/supervisord/conf.d/${app_name}-websockets.conf",
        owner   => 'vagrant',
        group   => 'vagrant',
        require => File['/etc/supervisord/conf.d'],
        content => template('supervisord/conf.d/myapp-websockets.conf')
    }

    file { "/var/log/gunicorn":
      path    => "/var/log/gunicorn/",
      owner   => 'vagrant',
      group   => 'vagrant',
      require => File['/etc/supervisord'],
      ensure  => directory
    }
    # file { "${venv_path}/bin/gunicorn_run.sh":
    #     path    => "${venv_path}/bin/gunicorn_run.sh",
    #     owner   => 'vagrant',
    #     group   => 'vagrant',
    #     mode    => 777,
    #     require => File['/etc/supervisord/conf.d'],
    #     content => template('supervisord/gunicorn/gunicorn_run.erb')
    # }
    file { "/etc/supervisord/conf.d/${app_name}-gunicorn.conf":
        path    => "/etc/supervisord/conf.d/${app_name}-gunicorn.conf",
        owner   => 'vagrant',
        group   => 'vagrant',
        # mode    => '0644',
        require => File['/etc/supervisord/conf.d'],
        content => template('supervisord/conf.d/myapp-gunicorn.conf')
    }
    exec { 'supervisord':
        # environment => "PY_PATH=/home/vagrant/.venvs/riddles/bin/python",
        # cwd     =>'/vagrant/',
        # owner   => 'vagrant',
        # group   => 'vagrant',
        command => "${venv_path}/bin/supervisord -c /etc/supervisord/supervisord.conf",
        logoutput => true,
        require => [
                File["/etc/supervisord/supervisord.conf"],
                File["/etc/supervisord/conf.d/${app_name}-celery.conf"],
                File["/etc/supervisord/conf.d/${app_name}-celerybeat.conf"],
                File["/etc/supervisord/conf.d/${app_name}-websockets.conf"],
                File["/etc/supervisord/conf.d/${app_name}-gunicorn.conf"],

            ]
    }
}
