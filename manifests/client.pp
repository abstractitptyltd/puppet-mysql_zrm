# Class mysql_zrm::client
#
# Sets up the client package and service on a database server
# Incompatible with mysql_zrm::server due to packages

class mysql_zrm::client {

  include mysql_zrm::params
  include mysql_zrm::install

  $pkg_name_client = $mysql_zrm::params::pkg_name_client
  $real_pkg_source_client = $mysql_zrm::params::real_pkg_source_client
  $pkg_provider = $mysql_zrm::params::pkg_provider

  xinetd::service { 'mysql-zrm-socket-server':
    port        => '25300',
    socket_type => 'stream',
    protocol    => 'tcp',
    user        => 'mysq',
    group       => 'mysql',
    instances   => '1',
    server      => '/usr/share/mysql-zrm/plugins/socket-server.pl',
  }

  exec { 'download_mysql_zrm_client':
    command => "wget ${real_pkg_source_client}",
    path    => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
    cwd     => '/tmp',
    creates => "/tmp/${pkg_name_client}",
  }

  package { 'mysql-zrm-client':
    ensure   => installed,
    provider => $pkg_provider,
    source   => "/tmp/${pkg_name_client}",
    require  => [Class['mysql_zrm::install'],Exec['download_mysql_zrm_client']],
  }

}

