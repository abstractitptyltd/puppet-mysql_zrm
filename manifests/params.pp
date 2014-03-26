# Class: mysql_zrm::params
#
# base params for mysql_zrm
#
# Parameters:
#   $report_email:
#       email to send reports
#
#   $temp_dir:
#       temp directory
#
#   $backup_destination:
#       backup directory
#
#   $server_type:
#       type of database server (mysql or mariadb)
#
#   $backup_level:
#       full or incremental backups (0 for full, 1 for incremental)
#
#   $backup_mode:
#       mod for backup (raw or logical)
#
#   $backup_type:
#       type of backup (regular or quick)
#
#   $comment:
#       comment you want to attach to a backup
#
#   $compression:
#       compressed backups (0 to disable)
#
#   $pkg_version:
#       version you want to install
#
#   $pkg_source:
#       url for package download
#

class mysql_zrm::params (
  $backup_server = "backup.${::domain}",
  $db_servers = ["db.${::domain}"],
  $report_email = '',
  $temp_dir = '/var/tmp/mysql-zrm',
  $backup_destination = '/var/lib/mysql-zrm',
  $default_character_set = '',
  $server_type = 'mysql',
  $backup_level = '0',
  $backup_mode = 'raw',
  $backup_type = 'regular',
  $comment = '',
  $compression = '',
  $version = '3.0',
  $pkg_version = '3.0',
  $pkg_source = 'http://www.zmanda.com/downloads/community/ZRM-MySQL',
  $pkg_name = '',
  $backup_db_user = 'backup',
  $backup_db_pass = '',
  $backup_db_server = '',
  $backup_db_port = '',
  $backup_db_socket = '',
  $retention_policy = '',
  $replication = '0',
  $incinterval = 'daily',
  $fullinterval = 'daily',
  $verbose = '0',
) {

  case $::osfamily {
    'Debian':  {
      $gzip_binary = '/bin/gzip'
      $pkg_provider = 'dpkg'
      $pkg_name_server = "mysql-zrm_${pkg_version}.0_all.deb"
      $pkg_name_client = "mysql-zrm-client_${pkg_version}.0_all.deb"
      $real_pkg_source_server = "${pkg_source}/${pkg_version}/Debian/${pkg_name_server}"
      $real_pkg_source_client = "${pkg_source}/${pkg_version}/Debian/${pkg_name_client}"
    }
    'RedHat':  {
      $gzip_binary = '/bin/gzip'
      $pkg_provider = undef
      $pkg_name_server = "MySQL-zrm_${pkg_version}.1_noarch.rpm"
      $pkg_name_client = "MySQL-zrm-client_${pkg_version}.1_noarch.rpm"
      $real_pkg_source_server = "${pkg_source}/${pkg_version}/RPM/${pkg_name_server}"
      $real_pkg_source_client = "${pkg_source}/${pkg_version}/RPM/${pkg_name_client}"
    }
  }

  validate_re($server_type, '^(mysql|mariadb)$',
  "${server_type} is not supported for \$server_type.
  Valid options are mysql or mariadb.")

  validate_re($backup_mode, '^(raw|logical)$',
  "${backup_mode} is not supported for \$backup_mode.
  Valid options are raw or logical.")

  validate_re($backup_type, '^(regular|quick)$',
  "${backup_type} is not supported for \$backup_type.
  Valid options are regular or quick.")

  $db_client_package = $server_type ? {
    default   => 'mysql-client',
    'mariadb' => 'mariadb-client',
  }
}
