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

class hpc_ha::config inherits hpc_ha {

  if $::hpc_ha::vips {
    create_resources(hpc_ha::vip, $::hpc_ha::vips)
  }
  if $::hpc_ha::vip_notify_scripts {
    create_resources(hpc_ha::vip_notify_script, $hpc_ha::vip_notify_scripts)
  }
  if $::hpc_ha::vservs {
    create_resources(hpc_ha::vserv, $::hpc_ha::vservs)
  }
}
