# == Class: postgresql
#
# === postgresql::config documentation
#
# ==== pg_hba concat order
# 00: header
# 01-99: user defined rules
class postgresql::config(
                          $version             = $postgresql::params::version_default,
                          $datadir             = $postgresql::params::datadir_default,
                          $listen              = '*',
                          $port                = '5432',
                          $max_connections     = '100',
                          $wal_level           = 'hot_standby',
                          $max_wal_senders     = '0',
                          $checkpoint_segments = '3',
                          $wal_keep_segments   = '0',
                          $hot_standby         = false,
                        ) inherits postgresql::params {

  file { "${datadir}/postgresql.conf":
    ensure  => 'present',
    owner   => $postgresql::params::postgresuser,
    group   => $postgresql::params::postgresgroup,
    mode    => '0600',
    content => template("${module_name}/postgresconf.erb"),
  }

  concat { "${datadir}/pg_hba.conf":
    ensure  => 'present',
    owner   => $postgresql::params::postgresuser,
    group   => $postgresql::params::postgresgroup,
    mode    => '0600',
  }

  concat::fragment{ "header pg_hba ${datadir}":
    target  => "${datadir}/pg_hba.conf",
    content => template("${module_name}/hba/header.erb"),
    order   => '00',
  }

}
