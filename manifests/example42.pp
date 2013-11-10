# = Class: keystone::example42
#
# Example42 puppi additions. To add them set:
#   my_class => 'keystone::example42'
#
class keystone::example42 {

  puppi::info::module { 'keystone':
    packagename => $keystone::package_name,
    servicename => $keystone::service_name,
    processname => 'keystone',
    configfile  => $keystone::config_file_path,
    configdir   => $keystone::config_dir_path,
    pidfile     => '/var/run/keystone.pid',
    datadir     => '',
    logdir      => '/var/log/keystone',
    protocol    => 'tcp',
    port        => '5000',
    description => 'What Puppet knows about keystone' ,
    # run         => 'keystone -V###',
  }

  puppi::log { 'keystone':
    description => 'Logs of keystone',
    log         => [ '/var/log/keystone/keystone.log' ],
  }

}
