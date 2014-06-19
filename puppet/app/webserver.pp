class app::webserver {
    if 'nginx' == $webserver {
        include app::webserver::nginxserver
    } else {
        include app::webserver::apache2
    }
}

import "webserver/*.pp"