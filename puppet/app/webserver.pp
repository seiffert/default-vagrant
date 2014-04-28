class app::webserver {
    if 'nginx' == $webserver {
        include app::webserver::nginx
    } else {
        include app::webserver::apache2
    }
}

import "webserver/*.pp"