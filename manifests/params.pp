# Class: keystone::params
#
# Defines all the variables used in the module.
#
class keystone::params {

  $package_name = $::osfamily ? {
    'Redhat' => 'openstack-keystone',
    default  => 'keystone',
  }

  $service_name = $::osfamily ? {
    'Redhat' => 'openstack-keystone',
    default  => 'keystone',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/keystone/keystone.conf',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'keystone',
  }

  $config_file_group = $::osfamily ? {
    default => 'keystone',
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/keystone',
  }

  case $::osfamily {
    'Debian','RedHat','Amazon': { }
    default: {
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    }
  }
}
