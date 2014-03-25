# Class: mysql_zrm::install
#
# Install packages for MySQL-ZRM
# purely internal class
#
class mysql_zrm::install {

  include mysql_zrm::params

  package { 'bsd-mailx':
    ensure => installed,
  }
  if (! defined(Package['libdbi-perl']) ) {
    package { 'libdbi-perl':
      ensure => installed,
    }
  }
  if (! defined(Package['libdbd-mysql-perl']) ) {
    package { 'libdbd-mysql-perl':
      ensure => installed,
    }
  }
  package { 'libxml-parser-perl':
    ensure => installed,
  }

}
