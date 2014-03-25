# Define Mysql_zrm::Backupset
# define for adding a backup set to mysql_zrm

define mysql_zrm::backupset (
  $databases,
  $fullhours,
  $ensure = 'present',
  $inchours = [],
  $mins = '0',
  $comment = '',
  $retention_policy = '',
  $backup_level = '0',
  $backup_mode = 'raw',
  $backup_type = 'regular',
  $backup_db_user = '',
  $backup_db_pass = '',
  $backup_db_server = $::fqdn,
  $backup_db_port = '',
  $backup_db_socket = '',
  $default_character_set = '',
  $report_email = '',
  $compression = true,
  $replication = '0',
  $incinterval = 'daily',
  $fullinterval = 'daily',
  $verbose = '0',
) {

  include mysql_zrm::params


  $backup_server = $mysql_zrm::params::backup_server

  if (is_array($databases)) {
    $db_list = join($databases, ' ')
  } else {
    $db_list = $databases
  }

  @@file { "/etc/mysql-zrm/${title}/":
    ensure  => directory,
    mode    => '0755',
    require => File['/etc/mysql-zrm'],
    tag     => "mysql_zrm_${backup_server}",
  }

  @@file {"/etc/mysql-zrm/${title}/mysql-zrm.conf":
    ensure  => $ensure,
    mode    => '0644',
    content => template('mysql_zrm/mysql-zrm.conf.erb'),
    require => File["/etc/mysql-zrm/${title}"],
    tag     => "mysql_zrm_${backup_server}",
  }

  # full backup cron
  @@cron {"mysql_zrm ${title} full backup":
    ensure  => $ensure,
    command => "/usr/bin/zrm-pre-scheduler --action backup --backup-set ${title} --backup-level 0 --interval ${fullinterval}",
    user    => 'root',
    hour    => $fullhours,
    minute  => $mins,
    tag     => "mysql_zrm_${backup_server}",
  }

  if (! empty($inchours)) {
    # incremental backup cron
    @@cron {"mysql_zrm ${title} incremental backup":
      ensure  => $ensure,
      command => "/usr/bin/zrm-pre-scheduler --action backup --backup-set ${title} --backup-level 1 --interval ${incinterval}",
      user    => 'root',
      hour    => $inchours,
      minute  => $mins,
      tag     => "mysql_zrm_${backup_server}",
    }
  } else {
    # incremental backup cron
    @@cron {"mysql_zrm ${title} incremental backup":
      ensure  => absent,
      command => "/usr/bin/zrm-pre-scheduler --action backup --backup-set ${title} --backup-level 1 --interval ${incinterval}",
      user    => 'root',
      hour    => $inchours,
      minute  => $mins,
      tag     => "mysql_zrm_${backup_server}",
    }
  }


}
