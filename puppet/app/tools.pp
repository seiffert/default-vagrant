class app::tools {
    package {["mlocate",
              "zip",
              "unzip",
              "strace",
              "tcpdump",
              "patch",
              "git",
              "mc"]:
        ensure => present,
    }

      case $::osfamily {
        Debian: {
                   package {["build-essential","vim"]: 
                      ensure => present, }
            }
        Redhat: {
                   package {["htop"]: 
                      ensure => present, 
                      require => Class["epel"], }
            }
      }

   exec {"find-utils-updatedb":
        command => "/usr/bin/updatedb &",
        require => Package["mlocate"],
    }
}