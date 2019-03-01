# ==== pg_hba concat order
# 00: header
# 01-99: user defined rules
class postgresql::hba::config inherits postgresql {

  if($postgresql::manage_pghba)
  {
    concat { "${datadir_path}/pg_hba.conf":
      ensure => 'present',
      owner  => $postgresql::params::postgresuser,
      group  => $postgresql::params::postgresgroup,
      mode   => '0600',
    }

    concat::fragment{ "header pg_hba ${datadir_path}":
      target  => "${datadir_path}/pg_hba.conf",
      content => template("${module_name}/hba/header.erb"),
      order   => '00',
    }
  }

}
