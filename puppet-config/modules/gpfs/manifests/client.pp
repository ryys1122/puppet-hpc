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

#
class gpfs::client (
  $cl_dir_mode              = $gpfs::params::cl_dir_mode,
  $cl_file_mod              = $gpfs::params::cl_file_mode,
  $cl_decrypt_passwd        = $gpfs::params::cl_decrypt_passwd,
  $cl_packages              = $gpfs::params::cl_packages,
  $cl_packages_ensure       = $gpfs::params::cl_packages_ensure,
  $cl_config_dir            = $gpfs::params::cl_config_dir,
  $cl_config                = $gpfs::params::cl_config,
  $cl_config_src            = $gpfs::params::cl_config_src,
  $cl_key                   = $gpfs::params::cl_key,
  $cl_key_src               = $gpfs::params::cl_key_src,
  $cluster                  = $gpfs::params::cluster,
  $service                  = $gpfs::params::service,
  $service_override_options = $gpfs::params::service_override_options,
  $public_key,
) inherits gpfs::params {

  validate_string($cl_dir_mode)
  validate_string($cl_file_mod)
  validate_string($cl_decrypt_passwd)
  validate_array($cl_packages)
  validate_string($cl_packages_ensure)
  validate_array($cl_config_dir)
  validate_absolute_path($cl_config)
  validate_string($cl_config_src)
  validate_absolute_path($cl_key)
  validate_string($cl_key_src)
  validate_string($cluster)
  validate_string($public_key)
  validate_string($service)
  validate_hash($service_override_options)

  anchor { 'gpfs::client::begin': } ->
  class { '::gpfs::client::install': } ->
  class { '::gpfs::client::config': } ->
  class { '::gpfs::client::service': } ->
  anchor { 'gpfs::client::end': }

}
