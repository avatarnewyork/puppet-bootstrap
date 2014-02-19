puppet-bootstrap
================

This bash program will bootstrap any supported OS with Puppet.  It installs the minimum required software and connects to your puppet master.  You can optionally specify an environment to use and optionally specify a custom script to execute before the puppet agent is started.

## Supported Operating Systems

* RHEL/CentOS 5.8-6.x
* Fedora 18,19,20
* Debian 6,7
* Ubuntu 10.04 (Lucid), 12.04 (Precise), 12.10 (Quantal), 13.04 (Raring), 13.10 (Saucy)

## Quick Start

On new puppet client, login as root and run the following replacing <PUPPET_MASTER_IP> with the IP address of your puppet master:
```bash
[root@puppetclient ~]# wget https://raw.github.com/avatarnewyork/puppet-bootstrap/master/puppet-bootstrap.sh
[root@puppetclient ~]# ./puppet-bootstrap.sh <PUPPET_MASTER_IP>
```

On the puppet master, sign the cert request and puppet will finish running on the new client _*(see: http://docs.puppetlabs.com/references/3.3.1/man/cert.html)*_

## Usage

puppet-bootstrap.sh takes the following parameters in order:

* PUPPET_MASTER_IP (required) - the IP address of your puppet master
* PUPPET_ENVIRONMENT (optional) - the environment to use (defaults to production which is puppet's default)
* CUSTOM_SCRIPT (optional) - a custom script to execute imediately before starting puppet agent

### Example Usage
```bash
[root@puppetclient ~]# ./puppet-bootstrap.sh 10.2.0.1 production createswap.sh
```

## compute-deploy Plugin

This script can be used as a compute-deploy plugin, allowing you to spin up a new box and bootstrap it with puppet.  More information on this project can be found here: https://github.com/avatarnewyork/compute-deploy

## Contributing

Contributers wanted!  Help make this script ubiquitous to all puppet supported platforms.  Make all pull requests to the remote dev branch.
