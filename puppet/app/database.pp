class app::mysql {
    mysql::db { "$mysql_database":
      user     => "$mysql_username",
      password => "$mysql_password",
    }
}
class app::database {
include app::mysql

    exec {"db-drop":
        require => [Package["php5-cli"],Class["app::mysql"]],
        command => "/bin/bash -c 'cd $vhostpath/$vhost.$domain && /usr/bin/php app/console doctrine:schema:drop --force'",
    }

    exec {"db-setup":
        require => [Exec["db-drop"], Package["php5-cli"], Class["app::mysql"]],
        command => "/bin/bash -c 'cd $vhostpath/$vhost.$domain && /usr/bin/php app/console doctrine:schema:create'",
    }

    exec {"db-default-data":
        require => [Exec["db-setup"], Package["php5-cli"], Class["app::mysql"]],
        command => "/bin/bash -c 'cd $vhostpath/$vhost.$domain && /usr/bin/php app/console doctrine:fixtures:load'",
        onlyif => "/usr/bin/test -d $vhostpath/$vhost.$domain/src/*/*/DataFixtures",
    }
}