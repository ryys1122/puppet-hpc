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

class pam::limits::config inherits pam::limits {

  # config_options has a key for each rule that is not written
  # to the file
  $options_array = values ($::pam::limits::config_options)
  hpclib::print_config { $::pam::limits::config_file :
    style => 'linebyline',
    data  => $options_array,
  }

  case $::osfamily {
    'Debian': {
      pam { 'Resource limits':
        ensure   => present,
        provider => augeas,
        service  => $::pam::limits::pam_service,
        type     => $::pam::limits::type,
        module   => $::pam::limits::module,
        control  => $::pam::limits::control,
        position => $::pam::limits::position,
      }
    }
    'RedHat': {
      notice('pam_limits activation not implemented for Redhat.')
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}, should be 'Debian' or 'Redhat'.")
    }
  }

}
