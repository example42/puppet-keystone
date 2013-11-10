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

This module installs, manages and configures keystone.

##Module Description

The module is based on **stdmod** naming standards version 0.9.0.

Refer to http://github.com/stdmod/ for complete documentation on the common parameters.

For a fully puppetized OpenStack implementation you'd better use the [official StackForge modules](https://github.com/stackforge/puppet-openstack).
This module is intended to be a quick replacement for scenarios where you need to manage configurations based on plain templates or where you have to puppettize an existing OpenStack setup.

##Setup

###Resources managed by keystone module
* This module installs the keystone package
* Enables the keystone service
* Can manage all the configuration files (by default no file is changed)

###Setup Requirements
* PuppetLabs stdlib module
* StdMod stdmod module
* Puppet version >= 2.7.x
* Facter version >= 1.6.2

###Beginning with module keystone

To install the package provided by the module just include it:

        include keystone

The main class arguments can be provided either via Hiera (from Puppet 3.x) or direct parameters:

        class { 'keystone':
          parameter => value,
        }

The module provides also a generic define to manage any keystone configuration file:

        keystone::conf { 'sample.conf':
          content => '# Test',
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


* Use custom source directory for the whole configuration directory, where present.

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


* Use the additional example42 subclass for puppi extensions

        class { 'keystone':
          my_class => 'keystone::example42'
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
