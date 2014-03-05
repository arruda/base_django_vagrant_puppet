class gunicorn (
  $app_name           = 'myapp',
  $python_path        = '',
  $manage_path        = '',
  $app_path           = '',
  $user               = '',
) {

    file { "/var/log/gunicorn":
      path    => "/var/log/gunicorn/",
      owner   => 'vagrant',
      group   => 'vagrant',
      require => File['/etc/supervisord'],
      ensure  => directory
    }

    file { "/etc/supervisord/conf.d/${app_name}-gunicorn.conf":
        path    => "/etc/supervisord/conf.d/${app_name}-gunicorn.conf",
        owner   => 'vagrant',
        group   => 'vagrant',
        require => File['/etc/supervisord/conf.d'],
        content => template('gunicorn/conf.d/myapp-gunicorn.conf')
    }
}
