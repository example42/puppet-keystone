#
# = Class: keystone
#
# This class installs and manages keystone
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class keystone (

  $package_name              = $keystone::params::package_name,
  $package_ensure            = 'present',

  $service_name              = $keystone::params::service_name,
  $service_ensure            = 'running',
  $service_enable            = true,

  $config_file_path          = $keystone::params::config_file_path,
  $config_file_replace       = $keystone::params::config_file_replace,
  $config_file_require       = 'Package[keystone]',
  $config_file_notify        = 'Service[keystone]',
  $config_file_source        = undef,
  $config_file_template      = undef,
  $config_file_content       = undef,
  $config_file_options_hash  = undef,

  $config_dir_path           = $keystone::params::config_dir_path,
  $config_dir_source         = undef,
  $config_dir_purge          = false,
  $config_dir_recurse        = true,

  $dependency_class          = undef,
  $my_class                  = undef,

  $monitor_class             = undef,
  $monitor_options_hash      = { } ,

  $firewall_class            = undef,
  $firewall_options_hash     = { } ,

  $scope_hash_filter         = '(uptime.*|timestamp)',

  $tcp_port                  = undef,
  $udp_port                  = undef,

  ) inherits keystone::params {


  # Class variables validation and management

  validate_bool($service_enable)
  validate_bool($config_dir_recurse)
  validate_bool($config_dir_purge)
  if $config_file_options_hash { validate_hash($config_file_options_hash) }
  if $monitor_options_hash { validate_hash($monitor_options_hash) }
  if $firewall_options_hash { validate_hash($firewall_options_hash) }

  $config_file_owner          = $keystone::params::config_file_owner
  $config_file_group          = $keystone::params::config_file_group
  $config_file_mode           = $keystone::params::config_file_mode

  $manage_config_file_content = default_content($config_file_content, $config_file_template)

  $manage_config_file_notify = pickx($config_file_notify)

  if $package_ensure == 'absent' {
    $manage_service_enable = undef
    $manage_service_ensure = stopped
    $config_dir_ensure = absent
    $config_file_ensure = absent
  } else {
    $manage_service_enable = $service_enable
    $manage_service_ensure = $service_ensure
    $config_dir_ensure = directory
    $config_file_ensure = present
  }


  # Resources managed

  if $keystone::package_name {
    package { $keystone::package_name:
      ensure   => $keystone::package_ensure,
    }
  }

  if $keystone::service_name {
    service { $keystone::service_name:
      ensure     => $keystone::manage_service_ensure,
      enable     => $keystone::manage_service_enable,
    }
  }

  if $keystone::config_file_path {
    file { 'keystone.conf':
      ensure  => $keystone::config_file_ensure,
      path    => $keystone::config_file_path,
      mode    => $keystone::config_file_mode,
      owner   => $keystone::config_file_owner,
      group   => $keystone::config_file_group,
      source  => $keystone::config_file_source,
      content => $keystone::manage_config_file_content,
      notify  => $keystone::manage_config_file_notify,
      require => $keystone::config_file_require,
    }
  }

  if $keystone::config_dir_source {
    file { 'keystone.dir':
      ensure  => $keystone::config_dir_ensure,
      path    => $keystone::config_dir_path,
      source  => $keystone::config_dir_source,
      recurse => $keystone::config_dir_recurse,
      purge   => $keystone::config_dir_purge,
      force   => $keystone::config_dir_purge,
      notify  => $keystone::config_file_notify,
      require => $keystone::config_file_require,
    }
  }


  # Extra classes

  if $keystone::dependency_class {
    include $keystone::dependency_class
  }

  if $keystone::my_class {
    include $keystone::my_class
  }

  if $keystone::monitor_class {
    class { $keystone::monitor_class:
      options_hash => $keystone::monitor_options_hash,
      scope_hash   => {}, # TODO: Find a good way to inject class' scope
    }
  }

  if $keystone::firewall_class {
    class { $keystone::firewall_class:
      options_hash => $keystone::firewall_options_hash,
      scope_hash   => {},
    }
  }

}

