#
# = Define: keystone::conf
#
# With this define you can manage any keystone configuration file
#
# == Parameters
#
# [*template*]
#   String. Optional. Default: undef. Alternative to: source, content.
#   Sets the module path of a custom template to use as content of
#   the config file
#   When defined, config file has: content => content($template),
#   Example: template => 'site/keystone/my.conf.erb',
#
# [*content*]
#   String. Optional. Default: undef. Alternative to: template, source.
#   Sets directly the value of the file's content parameter
#   When defined, config file has: content => $content,
#   Example: content => "# File manage by Puppet \n",
#
# [*source*]
#   String. Optional. Default: undef. Alternative to: template, content.
#   Sets the value of the file's source parameter
#   When defined, config file has: source => $source,
#   Example: source => 'puppet:///site/keystone/my.conf',
#
# [*ensure*]
#   String. Default: present
#   Manages config file presence. Possible values:
#   * 'present' - Create and manages the file.
#   * 'absent' - Remove the file.
#
# [*path*]
#   String. Optional. Default: $config_dir/$title
#   The path of the created config file. If not defined a file
#   name like the  the name of the title a custom template to use as content of configfile
#   If defined, configfile file has: content => content("$template")
#
# [*mode*] [*owner*] [*group*] [*notify*] [*require*] [*replace*]
#   String. Optional. Default: undef
#   All these parameters map directly to the created file attributes.
#   If not defined the module's defaults are used.
#   If defined, config file file has, for example: mode => $mode
#
# [*options_hash*]
#   Hash. Default undef. Needs: 'template'.
#   An hash of custom options to be used in templates to manage any key pairs of
#   arbitrary settings.
#
define keystone::conf (

  $source       = undef,
  $template     = undef,
  $content      = undef,

  $path         = undef,
  $mode         = undef,
  $owner        = undef,
  $group        = undef,
  $notify       = 'class_default',
  $require      = undef,
  $replace      = undef,

  $options_hash = undef,

  $ensure       = present ) {

  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent. WARNING: If set to absent the conf file is removed.')

  include keystone

  $manage_path    = pickx($path, "${keystone::config_dir_path}/${name}")
  $manage_content = default_content($content, $template)
  $manage_mode    = pickx($mode, $keystone::config_file_mode)
  $manage_owner   = pickx($owner, $keystone::config_file_owner)
  $manage_group   = pickx($group, $keystone::config_file_group)
  $manage_require = pickx($require, $keystone::config_file_require)
  $manage_replace = pickx($replace, $keystone::config_file_replace)
  $manage_notify  = $notify ? {
    'class_default' => $keystone::manage_config_file_notify,
    default         => $notify,
  }

  file { "keystone_conf_${name}":
    ensure  => $ensure,
    source  => $source,
    content => $manage_content,
    path    => $manage_path,
    mode    => $manage_mode,
    owner   => $manage_owner,
    group   => $manage_group,
    require => $manage_require,
    notify  => $manage_notify,
    replace => $manage_replace,
  }

}

