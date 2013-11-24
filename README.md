#keystone

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Resources managed by keystone module](#resources-managed-by-keystone-module)
    * [Setup requirements](#setup-requirements)
    * [Beginning with module keystone](#beginning-with-module-keystone)
4. [Usage](#usage)
5. [Operating Systems Support](#operating-systems-support)
6. [Development](#development)

##Overview

This module installs, manages and configures keystone and its services.

##Module Description

The module is based on **stdmod** naming standards version 0.9.0.

Refer to [http://github.com/stdmod/](http://github.com/stdmod/) for complete documentation on the common parameters.

For a fully automated Puppet setup of OpenStack you'd better use the official [StackForge modules](https://github.com/stackforge/puppet-openstack).
This module is intended to be a quick replacement for setups where you want to manage configurations based on plain template files or where you want to puppettize an existing OpenStack installation.

##Setup

###Resources managed by keystone module
* This module installs the keystone package (in case of multiple services, the keystone-api package is installed)
* Enables the keystone service (in case of multiple services, the keystone-api service is managed)
* Can manage all the configuration files (by default no file is changed)
* Can manage any keystone service and its configuration file (by default no file is changed)

###Setup Requirements
* PuppetLabs [stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib)
* StdMod [stdmod module](https://github.com/stdmod/stdmod)
* Puppet version >= 2.7.x
* Facter version >= 1.6.2

###Beginning with module keystone

To install the package provided by the module just include it:

        include keystone

The main class arguments can be provided either via Hiera (from Puppet 3.x) or direct parameters:

        class { 'keystone':
          parameter => value,
        }

The module provides a generic define to manage any keystone configuration file in /etc/keystone:

        keystone::conf { 'sample.conf':
          content => '# Test',
        }

A define to manage the package/service/configfile of single keystone services. To install the package and run the service:

        keystone::generic_service { 'keystone-registry': }

To provide a configuration file for the service (alternative to keystone::conf):

        keystone::generic_service { 'keystone-registry':
          config_file_template => 'site/keystone/keystone-registry.conf
        }

##Usage

* A common way to use this module involves the management of the main configuration file via a custom template (provided in a custom site module):

        class { 'keystone':
          config_file_template => 'site/keystone/keystone.conf.erb',
        }

* You can write custom templates that use setting provided but the config_file_options_hash paramenter

        class { 'keystone':
          config_file_template      => 'site/keystone/keystone.conf.erb',
          config_file_options_hash  => {
            opt  => 'value',
            opt2 => 'value2',
          },
        }

* Use custom source (here an array) for main configuration file. Note that template and source arguments are alternative.

        class { 'keystone':
          config_file_source => [ "puppet:///modules/site/keystone/keystone.conf-${hostname}" ,
                                  "puppet:///modules/site/keystone/keystone.conf" ],
        }


* Recurse from a custom source directory for the whole configuration directory (/etc/keystone).

        class { 'keystone':
          config_dir_source  => 'puppet:///modules/site/keystone/conf/',
        }

* Use custom source directory for the whole configuration directory and purge all the local files that are not on the dir.
  Note: This option can be used to be sure that the content of a directory is exactly the same you expect, but it is desctructive and may remove files.

        class { 'keystone':
          config_dir_source => 'puppet:///modules/site/keystone/conf/',
          config_dir_purge  => true, # Default: false.
        }

* Use custom source directory for the whole configuration dir and define recursing policy.

        class { 'keystone':
          config_dir_source    => 'puppet:///modules/site/keystone/conf/',
          config_dir_recursion => false, # Default: true.
        }

* Do not trigger a service restart when a config file changes.

        class { 'keystone':
          config_dir_notify => '', # Default: Service[keystone]
        }

##Operating Systems Support

This is tested on these OS:
- RedHat osfamily 6
- Ubuntu 12.04


##Development

Pull requests (PR) and bug reports via GitHub are welcomed.

When submitting PR please follow these quidelines:
- Provide puppet-lint compliant code
- If possible provide rspec tests
- Follow the module style and stdmod naming standards

When submitting bug report please include or link:
- The Puppet code that triggers the error
- The output of facter on the system where you try it
- All the relevant error logs
- Any other information useful to undestand the context
