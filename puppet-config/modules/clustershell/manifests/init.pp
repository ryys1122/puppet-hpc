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

class clustershell (
  $packages         = $::clustershell::params::packages,
  $packages_ensure  = $::clustershell::params::packages_ensure,
  $groups_file      = $::clustershell::params::groups_file,
  $groups_yaml_file = $::clustershell::params::groups_yaml_file,
  $groups           = $::clustershell::params::groups,
  $groups_options   = {},
) inherits clustershell::params {
  validate_hash($groups)
  validate_hash($groups_options)
  validate_absolute_path($groups_file)
  validate_absolute_path($groups_yaml_file)

  $_groups_options = deep_merge($::clustershell::params::groups_options_default, $groups_options)

  anchor { 'clustershell::begin': } ->
  class { '::clustershell::install': } ->
  class { '::clustershell::config': } ->
  anchor { 'clustershell::end': }

}
