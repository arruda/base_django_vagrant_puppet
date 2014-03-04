class celery (
  $app_name           = 'myapp',
  $python_path        = '',
  $manage_path        = '',
  $app_path           = '',
  $user               = '',
) {

    file { "/var/log/celeryd/":
      path    => "/var/log/celeryd/",
      owner   => 'vagrant',
      group   => 'vagrant',
      ensure  => directory
    }
    file { "/var/log/celerybeat/":
      path    => "/var/log/celerybeat/",
      owner   => 'vagrant',
      group   => 'vagrant',
      ensure  => directory
    }

    file { "/etc/supervisord/conf.d/${app_name}-celery.conf":
        path    => "/etc/supervisord/conf.d/${app_name}-celery.conf",
        owner   => 'vagrant',
        group   => 'vagrant',
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

}
