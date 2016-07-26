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

# HTTP server for slurm-web API
#
# ## Hiera
# * `profiles::jobsched::user`
# * `profiles::http::slurmweb::config_options`
class profiles::http::slurmweb {

  ## Hiera lookups

  $slurm_user     = hiera('profiles::jobsched::user')
  $config_options = hiera_hash('profiles::http::slurmweb::config_options')
  # Pass config options as a class parameter

  class { '::apache' :
    mpm_module => 'event',
  }

  class { '::slurmweb':
    config_options => $config_options,
    slurm_user     => $slurm_user,
  }

}