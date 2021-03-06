##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

class nscang::server (
  $install_manage      = $::nscang::server::params::install_manage,
  $packages_manage     = $::nscang::server::params::packages_manage,
  $packages            = $::nscang::server::params::packages,
  $packages_ensure     = $::nscang::server::params::packages_ensure,
  $services_manage     = $::nscang::server::params::services_manage,
  $services            = $::nscang::server::params::services,
  $services_ensure     = $::nscang::server::params::services_ensure,
  $services_enable     = $::nscang::server::params::services_enable,
  $config_manage       = $::nscang::server::params::config_manage,
  $config_file         = $::nscang::server::params::config_file,
  $user                = $::nscang::server::params::user,
  $cmd_file            = $::nscang::server::params::cmd_file,
  $identity            = $::nscang::server::params::identity,
  $password,
) inherits nscang::server::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($services_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $services_manage {
    validate_array($services)
    validate_string($services_ensure)
    validate_bool($services_enable)
  }

  if $install_manage or $config_manage {
    validate_string($user)
  }

  if $config_manage {
    validate_absolute_path($config_file)
    validate_absolute_path($cmd_file)
    validate_string($identity)
    validate_string($password)
  }

  anchor { 'nscang::server::begin': } ->
  class { '::nscang::server::install': } ->
  class { '::nscang::server::config': } ->
  class { '::nscang::server::service': } ->
  anchor { 'nscang::server::end': }

}
