#
class gpfs::params {

  # File and directory modes
  $cl_dir_mode            = '755' 
  $cl_file_mode           = '640'

  # Password to decrypt encrypted files
  $cl_decrypt_passwd      = 'password'
  
  # Packages to install
  # It is assumed that license files are managed with a
  # special package : gpfs.lum for both Debian and Red Hat
  case $::osfamily {
    'Debian': {
      $cl_base               = [
        'gpfs.base',
        'gpfs.msg.en-us',
        'gpfs.lum',
      ]
      case $::operatingsystemmajrelease {
        '8': {
          $cl_kernel         = ['gpfs.gpl-3.16.0-4-amd64']
        }
        '7': {
          $cl_kernel         = ['gpfs.gpl-3.2.0-4-amd64']
        }
        default: {}
      }
      $sr_packages           = []
      $sr_packages_ensure    = ''
    }
    'Redhat': {
      $cl_base               = [
        'gpfs.base',
        'gpfs.msg.en_US',
        'gpfs.ext',
        'gpfs.gskit',
        'gpfs.lum',
      ]
      case $::operatingsystemmajrelease {
        '7': {
          $cl_kernel         = ['gpfs.gplbin-3.10.0-123.el7.x86_64']
        }
        '6': {
          $cl_kernel         = ['gpfs.gplbin-2.6.32-431.el6.x86_64']
        }
        default: {}
      }
      $sr_packages           = ['gpfs.docs','set_dma_latency']
      $sr_packages_ensure    = 'present'
    }
    default: {}
    $cl_packages       = [$cl_base, $cl_kernel]
    $cl_packages_ensure= 'present'
    $cl_config_dir     = [
      '/var/mmfs',
      '/var/mmfs/gen',
      '/var/lock',
      '/var/lock/subsys',
      '/usr/lpp',
      '/usr/lpp/mmfs',
      '/usr/lpp/mmfs/lib',
      '/var/mmfs/ssl',
      '/var/mmfs/ssl/stage',
    ]
    $cl_config         = '/var/mmfs/gen/mmsdrfs'
    $cl_config_src     = ''
    $cl_key            = '/var/mmfs/ssl/stage/genkeyData1'
    $cl_key_src        = ''
    $cl_perf           = '/usr/lpp/mmfs/samples/perf'
    $cl_perf_src       = ''
  }

}