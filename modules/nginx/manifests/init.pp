class nginx (
  $upstream_name      = 'myupstream',
  $upstream_server      = 'unix:/tmp/myupstream.sock',

  $server_name      = 'example.com',
  $access_log      = '',
  $error_log      = '',

  $app_path      = '',
) {

    package { [
        'nginx'
      ]:
      ensure  => 'installed',
    }->

    file { "/etc/nginx/sites-available/${server_name}.vhost":
      path    => "/etc/nginx/sites-available/${server_name}.vhost",
      owner   => 'vagrant',
      group   => 'vagrant',
      require => Package['nginx'],
      content => template('nginx/myapp.vhost')
    }->

    file { "/etc/nginx/sites-enabled/${server_name}.vhost":
       ensure => 'link',
       target => "/etc/nginx/sites-available/${server_name}.vhost",
       require => File["/etc/nginx/sites-available/${server_name}.vhost"],
    }->
    file { "/etc/nginx/sites-enabled/default":
       ensure => 'absent',
    }->

    service { 'nginx':
        ensure => running,
        require => Package['nginx'],
    }
}
