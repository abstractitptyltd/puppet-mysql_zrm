# == Class: mysql_zrm
#
# Manage Amanda Mysql-ZRM with Puppet
# Installs and configures the client and server in separate classes
# the mysql_zrm::backupset manages the individual backups
#
# === Parameters
#
# Parameters are set in the params subclass.
#
# === Examples
#
#  class { mysql_zrm:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <pete@abstractit.com.au>
#
# === Copyright
#
# Copyright 2014 Abstract IT Pty Ltd, unless otherwise noted.
#

class mysql_zrm {

  include mysql_zrm::params
  include mysql_zrm::install

  $backup_server = $mysql_zrm::params::backup_server
  $db_servers = $mysql_zrm::params::db_servers

  if ( member($db_servers,$::clientcert ) ) {
    include mysql_zrm::client
  }
  if ( $::clientcert == $backup_server ) {
    include mysql_zrm::server
  }

}
