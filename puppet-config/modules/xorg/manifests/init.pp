##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2016 EDF S.A.                                      #
#  Contact: CCN-HPC <dsp-cspit-ccn-hpc@edf.fr>                           #
#                                                                        #
#  This program is free software; you can redistribute in and/or         #
#  modify it under the terms of the GNU General Public License,          #
#  version 2, as published by the Free Software Foundation.              #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
##########################################################################

class xorg (
  $service         = $::xorg::params::service,
  $service_ensure  = $::xorg::params::service_ensure,
  $service_enable  = $::xorg::params::service_enable,
  $service_file    = $::xorg::params::service_file,
  $service_options = {},
  $packages        = $::xorg::params::packages,
  $packages_ensure = $::xorg::params::packages_ensure,
  $config_file     = $::xorg::params::config_file,
  $bus_id          = $::xorg::params::bus_id,
  $driver          = $::xorg::params::driver,
  $config_content  = undef,
  $config_source   = undef,
) inherits xorg::params {
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_absolute_path($service_file)
  validate_hash($service_options)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_string($bus_id)
  validate_string($driver)

  $_service_options = deep_merge($::xorg::params::service_options_defaults, $service_options)

  case $driver {
    'auto': {
      $config_ensure  = 'absent'
      $_config_content = undef
    }
    'custom': {
      # A configuration is required with custom driver, then fail is undef
      if $config_content == undef and
         $config_source == undef {
        fail('For driver custom, you should provide a config_content or a config_source')
      }

      $config_ensure  = 'present'
      $_config_content = $config_content
    }
    'nvidia': {
      $config_ensure = 'present'
      # Default to the module template if none is provided
      if $config_content == undef and $config_source == undef {
        $_config_content = template('xorg/xorg.nvidia.conf.erb')
      } else {
        $_config_content = $config_content
      }
    }
    default: {
      fail("Unsupported xorg driver '${driver}', should be: 'auto', 'custom' or 'nvidia'.")
    }
  }


  anchor { 'xorg::begin': } ->
  class { '::xorg::install': } ->
  class { '::xorg::config': } ->
  class { '::xorg::service': } ->
  anchor { 'xorg::end': }

}
