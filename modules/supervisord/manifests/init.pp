class supervisord () {
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

    file { "/etc/supervisord/supervisord.conf":
        path    => "/etc/supervisord/supervisord.conf",
        owner   => 'vagrant',
        group   => 'vagrant',
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

}
