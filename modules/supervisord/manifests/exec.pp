class supervisord::exec {

    exec { 'supervisord':
        # environment => "PY_PATH=/home/vagrant/.venvs/riddles/bin/python",
        # cwd     =>'/vagrant/',
        # owner   => 'vagrant',
        # group   => 'vagrant',
        command => "${venv_path}/bin/supervisord -c /etc/supervisord/supervisord.conf",
        logoutput => true,
        require => File["/etc/supervisord/supervisord.conf"]
    }
}
