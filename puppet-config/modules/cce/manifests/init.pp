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

class cce (
  $packages         = $cce::params::packages,
  $packages_ensure  = $cce::params::packages_ensure,
  $default_file     = $cce::params::default_file,
  $default_options  = $cce::params::default_options,
) inherits cce::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($default_file)
  validate_hash($default_options)

  anchor { 'cce::begin': } ->
  class { '::cce::install': } ->
  class { '::cce::config': } ->
  anchor { 'cce::end': }

}
