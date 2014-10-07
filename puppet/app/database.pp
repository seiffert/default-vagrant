class app::database {
    if 'mysql' == "$database" {
        include app::database::mysql
    } else {
        include app::database::postgresql
    }
}

import "database/*.pp"