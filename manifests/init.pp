class cups_sane (
  $packages           = $cups_sane::params::packages,
  $packages_ensure    = $cups_sane::params::packages_ensure,
  $is_cups_client     = $cups_sane::params::is_cups_client,
  $is_cups_server     = $cups_sane::params::is_cups_server,
  $remote_cups_server = $cups_sane::params::is_cups_server,
  $service_provider   = $cups_sane::params::service_provider,
) inherits cups_sane::params {

  class { 'cups_sane::install':
    packages_ensure => $packages_ensure,
    packages        => $packages,
  }

  if $is_cups_client {
    class { 'cups_sane::cups::client::config':
      remote_cups_server => $remote_cups_server,
    }

    class { 'cups_sane::cups::client::service':
      service_provider => $service_provider,
    }

    Class['cups_sane::install'] ->
    Class['cups_sane::cups::client::config'] ~>
    Class['cups_sane::cups::client::service']
  }
  if $is_cups_server {
    Class['cups_sane::install'] ->
    Class['cups_sane::cups::server::config'] ~>
    Class['cups_sane::cups::server::service']
  }

#  service { "saned":
#    ensure      => "running",
#    require     => Package['sane-backends'],
#    enable      => "true",
#    subscribe   => Exec['enable_hpaio'],
#  }
#  service { "cupsd":
#    ensure      => "running",
#    require     => [ Package['cups'], Package['hpcups'], File['/etc/cups/ppd/LaserJet.ppd'], ],
#    enable      => "true",
#  }

#  exec { 'enable_hpaio':
#    command	=> "echo hpaio >> /etc/sane.d/dll.conf",
#    onlyif	=> "test `grep -c hpaio /etc/sane.d/dll.conf` == 0",
#    require	=> Package['sane-backends'],
#  }

#  file { '/etc/cups/printcap':
#    ensure      => file,
#    require     => Package['cups'],
#    owner	=> "root",
#    group	=> "_cups",
#    mode	=> "0644",
#    notify      => Service["cupsd"],
#    content     => template('cups_sane/printcap.erb'),
#  }
#  file { '/etc/cups/printers.conf.puppet':
#    ensure      => file,
#    require     => Package['cups'],
#    owner	=> "root",
#    group	=> "_cups",
#    mode	=> "0600",
#    notify      => Service["cupsd"],
#    content     => template('cups_sane/printers.conf.erb'),
#  }
#  exec { "cups_sane_copy_printers.conf":
#    command     => "/bin/cp /etc/cups/printers.conf.puppet /etc/cups/printers.conf",
#    unless      => 'grep LaserJet /etc/cups/printers.conf 2>/dev/null',
#    subscribe   => File["/etc/cups/printers.conf.puppet"],
#    notify      => Service['cupsd'],
#    refreshonly => true,
#  }
#  file { '/etc/cups/ppd/LaserJet.ppd':
#    ensure      => file,
#    require     => Package['cups'],
#    owner	=> "root",
#    group	=> "_cups",
#    mode	=> "0644",
#    notify      => Service["cupsd"],
#    source      => "puppet:///modules/cups_sane/LaserJet.ppd",
#  }

}
