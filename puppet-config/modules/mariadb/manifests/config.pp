class mariadb::config {
  
  if $mariadb::config_manage {

    $tmp_mysql_conf_options   = {
      'client'              => {
        'password'            => $mariadb::mysql_root_pwd,
      },
      'mysql_upgrade'       => {
        'password'            => $mariadb::mysql_root_pwd,
      },
    }

    ### Merge first section ###
    $client  = merge($mariadb::mysql_conf_options['client'], $tmp_mysql_conf_options['client']) 
    $upgrade = merge($mariadb::mysql_conf_options['mysql_upgrade'], $tmp_mysql_conf_options['mysql_upgrade'])
    $local_mysql_conf_options   = {
      'client'        => $client,
      'mysql_upgrade' => $upgrade,
    }

    file { $mariadb::conf_dir_path : 
      ensure    => 'directory',
    }

    file { $mariadb::galera_dir_path :
      ensure    => 'directory',
      require   => File[$mariadb::conf_dir_path],
    }

    hpclib::print_config { $mariadb::galera_conf_file : 
      data      => $mariadb::galera_conf_options,
      style     => 'ini',
    }

    hpclib::print_config { $mariadb::main_conf_file :
      style     => 'ini',
      data      => $local_mysql_conf_options,
      mode      => '0600',
      backup    => false,
      require   => File[$mariadb::conf_dir_path],
    }
  }
}