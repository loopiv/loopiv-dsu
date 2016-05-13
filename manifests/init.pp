# == Class: dsu
#
# Dell System Update (DSU)
#
# === Parameters
#
# No parameters.
#
# === Variables
#
# No variables.
#
# === Examples
#
#  class { 'dsu': }
#
# === Authors
#
# Vipool Rathod <vipool.rathod@nasa.gov>
#
# === Copyright
#
# Copyright 2016 NASA/GSFC/619.0
#
class dsu {

  exec { 'newaliases':
    command     => 'newaliases',
    path        => [ '/usr/bin', '/usr/sbin', '/bin', ],
    refreshonly => true,
  }
  exec { 'omsa-config-alerts':
    command     => '/usr/local/sbin/omsa-config-alerts.sh',
    refreshonly => true,
    require     => [ 'File[/usr/local/sbin/omsa-config-alerts.sh]',
                     'File[/usr/local/sbin/om-alert.sh]',
                   ],
    before      => 'File[/etc/cron.hourly/omsa-alert.cron]',
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }
  file { '/etc/cron.hourly/omsa-alert.cron':
    ensure => file,
    source => 'puppet:///modules/dsu/omsa-alert.cron',
  }
  file { '/usr/local/sbin/om-alert.sh':
    ensure => file,
    source => 'puppet:///modules/dsu/om-alert.sh',
  }
  file { '/usr/local/sbin/omsa-config-alerts.sh':
    ensure => file,
    source => 'puppet:///modules/dsu/omsa-config-alerts.sh',
  }

  file_line { 'omsa-alerts':
    path   => '/etc/aliases',
    line   => 'omsa-alerts:    root',
    match  => '^omsa-alerts:',
    notify => 'Exec[newaliases]',
  }

  package { [ 'OpenIPMI', 'dell-system-update', 'srvadmin-all', ]:
    ensure  => present,
    require => [ 'Yumrepo[dell-system-update_independent]',
                 'Yumrepo[dell-system-update_dependent]',
               ],
  }

  $srvadmin_services_script = '/opt/dell/srvadmin/sbin/srvadmin-services.sh'
  service { 'srvadmin-services':
    ensure   => running,
    provider => 'init',
    start    => "${srvadmin_services_script} start",
    stop     => "${srvadmin_services_script} stop",
    status   => "${srvadmin_services_script} status",
    restart  => "${srvadmin_services_script} restart",
    require  => 'Package[srvadmin-all]',
    notify   => 'Exec[omsa-config-alerts]',
  }

  yumrepo { 'dell-system-update_independent':
    ensure   => present,
    descr    => 'dell-system-update_independent',
    baseurl  => 'http://linux.dell.com/repo/hardware/dsu/os_independent/',
    gpgcheck => '1',
    gpgkey   => 'http://linux.dell.com/repo/hardware/dsu/public.key',
    enabled  => '1',
    exclude  => 'dell-system-update*.i386',
  }

  yumrepo { 'dell-system-update_dependent':
    ensure     => present,
    descr      => 'dell-system-update_dependent',
    mirrorlist => 'http://linux.dell.com/repo/hardware/dsu/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1',
    gpgcheck   => '1',
    gpgkey     => 'http://linux.dell.com/repo/hardware/dsu/public.key',
    enabled    => '1',
  }

}
