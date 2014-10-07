# My Vagrant/Puppet Default Setup 

## NEWS 
- Postfix support
- SMTP support ( GMail & Mailgun tested )
- Centos 6 
- PHP timezone ( only FPM )

## Archive
- Nginx SSL support
- Vagrant v2 support
- Automatic ssl certificate generation
- Custom domain support
- Apache SSL support
- Apache & Stdlib module upgrade
- New concat module
- MySQL custom user, password, database support
- MySQL custom root password
- Xdebug support only phpfpm
- Small bugfix
- Add jfryman/nginx module
- Dropped old nginx module
- PHPFPM slow querylog
- New tools package from tcpdump

## Tested
Ubuntu 12.04/14.04
Centos 6

## NOTE
- GMail: https://support.google.com/mail/bin/answer.py?answer=78754

## Setup

-   Install vagrant on your system
    see [vagrantup.com](http://docs.vagrantup.com/v2/getting-started/index.html)

-   Install vagrant-hostmaster on your system
    see [mosaicxm/vagrant-hostmaster](https://github.com/mosaicxm/vagrant-hostmaster#installation)

-   Get a base box with puppet support
    see [vagrantup.com docs](http://docs.vagrantup.com/v2/getting-started/boxes.html)

-   Get a custom box with puppet support
    see [pigri/vagrantboxes](https://github.com/pigri/vagrant-boxes)

-   Get a copy of this repository. You can do this either by integrating it as a git submodule or by just checking it out and copying the files. 
    Prefarably, the contents of this repository should be placed in a directory `vagrant` inside your project's root dir.

-   Copy `vagrant/Personalization.dist` to `vagrant/Personalization` and modify `vagrant/Personalization` according to your needs.

    Example:
    ```ruby
    $vhost = "test"
    $domain = "dev"
    $ip = "192.168.10.42"

    $use_nfs = true

    $base_box = "ubuntu-14.04-server-amd64"

    $webserver = "nginx"
    ```
        
    -   Execute "vagrant up" in the directory vagrant.

## Infrastructure

After performing the steps listed above, you will have the following environment set up:

- A running virtual machine with your project on it
- Your project directory will be mounted as a shared folder in this virtual machine
- Your project will be accessible via a browser (go to `http://{$vhost}.{$domain}/[app_dev.php]` or `https://{$vhost}.{$domain}/[app_dev.php]` )
- You can now start customizing the new virtual machine. In most cases, the machine should correspond to the infrastructure your production server(s) provide.

## TODO
- Debian support