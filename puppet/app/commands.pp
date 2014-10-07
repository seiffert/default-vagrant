class app::commands {
	
    exec {"clear-symfony-cache":
        require => Class["app::php"],
        command => "/bin/bash -c 'cd $vhostpath/$vhost.$domain && /usr/bin/php app/console cache:clear --env=dev && /usr/bin/php app/console cache:clear --env=prod'",
    }

    exec {"db-drop":
        require => [Class["app::php"],Class["app::database::$database"]],
        command => "/bin/bash -c 'cd $vhostpath/$vhost.$domain && /usr/bin/php app/console doctrine:schema:drop --force'",
    }

    exec {"db-setup":
        require => [Exec["db-drop"], Class["app::php"],Class["app::database::$database"]],
        command => "/bin/bash -c 'cd $vhostpath/$vhost.$domain && /usr/bin/php app/console doctrine:schema:create'",
    }

    exec {"db-default-data":
        require => [Exec["db-setup"], Class["app::php"],Class["app::database::$database"]],
        command => "/bin/bash -c 'cd $vhostpath/$vhost.$domain && /usr/bin/php app/console doctrine:fixtures:load'",
        onlyif => "/usr/bin/test -d $vhostpath/$vhost.$domain/src/*/*/DataFixtures",
    }

}