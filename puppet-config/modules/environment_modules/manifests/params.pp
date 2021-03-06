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

class environment_modules::params {

  #### Module variables
  $packages_ensure = 'latest'
  $packages        = ['environment-modules']

  #### Defaults values
  case $::osfamily {
    'RedHat': {
      $rootdirmodules = '/usr/share/Modules/modulefiles'
      $config_file    = '/usr/share/Modules/init/.modulespath'
    }
    'Debian': {
      $rootdirmodules = '/etc/modules'
      $config_file    = '/etc/environment-modules/modulespath'
    }
    default: {
      fail("Unsupported OS Family '${::osfamily}', should be: 'Debian', 'Redhat'.")
    }
  }

  $config_options = [
    "${rootdirmodules}/base",
    "${rootdirmodules}/compiler",
    "${rootdirmodules}/debugger",
    "${rootdirmodules}/devel",
    "${rootdirmodules}/mpi",
  ]

}
