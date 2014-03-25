abstractit-mysql_zrm
====

####Table of Contents

1. [Overview - What is the mysql_zrm module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [How it works - The basics of getting started with mysql_zrm](#how-it-works)
4. [Usage - How to set it up](#usage)
5. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Support - Where to get support](#support)

Overview
--------

Puppet module for setting up Zamanda MySQL-ZRM to backup databases from a MariaDB, Percona or MySQL server.

Module Description
------------------

Manages full and incremental backups of selected databases using MySQL-ZRM.
It can use a server <-> client setup or the server can be installed directly onto your database server to do backups there.
Backupsets can be setup on any node and get exported to the server of your choosing.
At this stage it doesn't manage database users to do the backups due to the variety of ways to implement this.
This may be implemented in a future release if I can find good modules for each server type.

How it works
------------

**what mysql_zrm affects:**

* configuration files for mysql_zrm
* cron jobs to do the backups
* expunging old backups

Usage
-----

### Setting up mysql_zrm

Automatic Client <-> Server mode.

	# override these variables if needed.
	`$mysql_zrm::params::db_servers` Array of database servers. (defaults to "db.${::domain}")
	`$mysql_zrm::params::backup_server` (defaults to "backup.${::domain}")

Setting these variables will automaticlly include the server or client class.

	# include this on your database and backup servers.
    include mysql_zrm

Manual Client <-> Server mode

	# include this on your database servers.
    include mysql_zrm::client

	# include this on your backup servers.
    include mysql_zrm::server
	
### Exporting backupsets for mysql_zrm servers

These will get exported to the

    mysql_zrm::backupset { 'testing':
      databases        => 'test',
      fullhours        => ['0','12'],
      backup_db_user   => 'backup',
      backup_db_pass   => 'PASSWORD',
      backup_db_server => $::fqdn,
    }	

#### `title`

Name for the backup

#### `ensure`

Whether to setup the backup set, defaults to present.

#### `databases`

Databases to backup.

#### `fullhours`

Hours to run the backup.

#### `backup_db_user`

Database user to use for the backup.

#### `backup_db_pass`

Password for the backup user.

#### `backup_db_server`

Database server.


Limitations
------------

Backupset config files and crons need stored configs on your puppet master. I recommend using PuppetDB for this.

Development
-----------

All development, testing and releasing is done by Abstract IT at this stage.
If you wish to join in let me know.

Support
-------
Please log tickets on the github issues page https://github.com/abstractitptyltd/puppet-mysql_zrm/issues
