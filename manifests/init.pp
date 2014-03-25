# == Class: mysql_zrm
#
# Manage Amanda Mysql-ZRM with Puppet
# Installs and configures the client and server in separate classes
# the mysql_zrm::backupset manages the individual backups
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
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
