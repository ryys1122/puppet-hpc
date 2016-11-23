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

class dns::client (
  $header      = $::dns::client::params::header,
  $domain      = $::dns::client::params::domain,
  $search      = $::dns::client::params::search,
  $options     = $::dns::client::params::options,
  $nameservers = $::dns::client::params::nameservers,
  $config_file = $::dns::client::params::config_file,
) inherits dns::client::params {

  validate_string($header)
  validate_string($domain)
  validate_string($search)
  validate_array($options)
  validate_array($nameservers)
  validate_absolute_path($config_file)

  anchor { 'dns::client::begin': } ->
  class { '::dns::client::config': } ->
  anchor { 'dns::client::end': }

}
