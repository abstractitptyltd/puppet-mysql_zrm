# Class: mysql_zrm::server
#
# install the mysql-zrm server package and sets up the global config file
#

class mysql_zrm::server {

  include mysql_zrm::params
  include mysql_zrm::install

  $temp_dir = $mysql_zrm::params::temp_dir
  $backup_destination = $mysql_zrm::params::backup_destination
  $default_character_set =$mysql_zrm::params::default_character_set
  $backup_level = $mysql_zrm::params::backup_level
  $backup_mode = $mysql_zrm::params::backup_mode
  $backup_type = $mysql_zrm::params::backup_type
  $comment = $mysql_zrm::params::comment
  $backup_db_user = $mysql_zrm::params::backup_db_user
  $backup_db_pass = $mysql_zrm::params::backup_db_pass
  $backup_db_server = $mysql_zrm::params::backup_db_server
  $backup_db_port = $mysql_zrm::params::backup_db_port
  $backup_db_socket = $mysql_zrm::params::backup_db_socket
  $report_email = $mysql_zrm::params::report_email
  $compression = $mysql_zrm::params::compression
  $real_pkg_source_server = $mysql_zrm::params::real_pkg_source_server
  $pkg_name_server = $mysql_zrm::params::pkg_name_server
  $pkg_provider = $mysql_zrm::params::pkg_provider
  $retention_policy = $mysql_zrm::params::retention_policy
  $replication = $mysql_zrm::params::replication
  $incinterval = $mysql_zrm::params::incinterval
  $fullinterval = $mysql_zrm::params::fullinterval
  $verbose = $mysql_zrm::params::verbose

  # import all backup jobs
  File <<| tag == "mysql_zrm_${::clientcert}" |>>
  Cron <<| tag == "mysql_zrm_${::clientcert}" |>>

  exec { 'download_mysql_zrm_server':
    command => "wget ${real_pkg_source_server}",
    path    => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
    cwd     => '/tmp',
    creates => "/tmp/${pkg_name_server}",
  }

  package { 'mysql-zrm':
    ensure   => installed,
    provider => $pkg_provider,
    source   => "/tmp/${pkg_name_server}",
    require  => [Class['mysql_zrm::install'],Exec['download_mysql_zrm_server']],
  }

  file { '/etc/mysql-zrm/':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0660',
    recurse => false,
  }

  file { '/etc/mysql-zrm/mysql-zrm.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0660',
    content => template('mysql_zrm/mysql-zrm.conf.erb'),
    require => File['/etc/mysql-zrm'],
  }

  file { $temp_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { $backup_destination:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }

  cron {'zrm purge':
    command => '/usr/bin/mysql-zrm --action purge',
    user    => 'root',
    hour    => '4',
    minute  => '0',
  }
}

