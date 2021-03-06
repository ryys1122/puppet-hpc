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

# NFS common
#
# For NFSv4 it is mandatory to have a working idmapd configuration, the
# most basic setup is for all the nodes to use the same idmapd domain.
#
# By default, idmapd will use the local domain name (`hostname -d`). If
# you wish to override this setting you can add a `idmapd_options`:
# ```
# class{ '::nfs':
#   idmapd_options => {
#     'General' => {
#       'Domain' => {
#         'comment' => 'Domain for the mapping',
#         'value'   => 'hpc.example.edu',
#       },
#     },
#   },
# }
# ```
#
# @param idmapd_options    Content of the idampd configuration file
# @param idmapd_file       Path of the idmapd configuration file
# @param default_options   Content of the default (syscfg) file parameter
#         for the nfs-common service
# @param default_file      Path of the default (syscfg) file parameter
#         for the nfs-common service (default: '/etc/default/nfs-common')
# @param packages_ensure   Install mode (`latest` or `present`) for the
#                          packages (default: `present`)
# @param packages          Array of packages names
# @param service_ensure    Ensure state of the service: `running` or
#                          `stopped` (default: running)
# @param service           Name of the service
# @param enabled_gssd      Enable gss daemon with the nfs service
class nfs (
  $idmapd_options  = {},
  $idmapd_file     = $::nfs::params::idmapd_file,
  $default_options = {},
  $default_file    = $::nfs::params::default_file,
  $service_ensure  = $::nfs::params::service_ensure,
  $service         = $::nfs::params::service,
  $packages_ensure = $::nfs::params::packages_ensure,
  $packages        = $::nfs::params::packages,
  $enable_gssd     = $::nfs::params::enable_gssd,
) inherits ::nfs::params {
  validate_absolute_path($idmapd_file)
  validate_hash($idmapd_options)
  validate_absolute_path($default_file)
  validate_hash($default_options)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($enable_gssd)

  $_idmapd_options = deep_merge($::nfs::params::idmapd_options_defaults, $idmapd_options)

  if $enable_gssd {
    $gssd_options = { 'NEED_GSSD' => 'yes', }
  } else {
    $gssd_options = {}
  }
  $tmp_default_options = deep_merge($::nfs::params::default_options_defaults, $gssd_options)
  $_default_options = deep_merge($tmp_default_options, $default_options)
  anchor { 'nfs::begin': } ->
  class { '::nfs::install': } ->
  class { '::nfs::config': } ~>
  class { '::nfs::service': } ->
  anchor { 'nfs::end': }

}
