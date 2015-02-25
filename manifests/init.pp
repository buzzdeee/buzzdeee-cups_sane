class cups_sane {
  $packages = ['sane-backends', 'hpaio', 'cups', 'hpcups', ]
  package { $packages:
    ensure => present,
  }
  service { "saned":
    ensure      => "running",
    require     => Package['sane-backends'],
    enable      => "true",
    subscribe   => Exec['enable_hpaio'],
  }
  service { "cupsd":
    ensure      => "running",
    require     => [ Package['cups'], Package['hpcups'], File['/etc/cups/ppd/LaserJet.ppd'], ],
    enable      => "true",
  }

  exec { 'enable_hpaio':
    command	=> "echo hpaio >> /etc/sane.d/dll.conf",
    onlyif	=> "test `grep -c hpaio /etc/sane.d/dll.conf` == 0",
    require	=> Package['sane-backends'],
  }

  file { '/etc/cups/printcap':
    ensure      => file,
    require     => Package['cups'],
    owner	=> "root",
    group	=> "_cups",
    mode	=> "0644",
    notify      => Service["cupsd"],
    content     => template('cups_sane/printcap.erb'),
  }
  file { '/etc/cups/printers.conf.puppet':
    ensure      => file,
    require     => Package['cups'],
    owner	=> "root",
    group	=> "_cups",
    mode	=> "0600",
    notify      => Service["cupsd"],
    content     => template('cups_sane/printers.conf.erb'),
  }
  exec { "cups_sane_copy_printers.conf":
    command     => "/bin/cp /etc/cups/printers.conf.puppet /etc/cups/printers.conf",
    unless      => 'grep LaserJet /etc/cups/printers.conf 2>/dev/null',
    subscribe   => File["/etc/cups/printers.conf.puppet"],
    notify      => Service['cupsd'],
    refreshonly => true,
  }
  file { '/etc/cups/ppd/LaserJet.ppd':
    ensure      => file,
    require     => Package['cups'],
    owner	=> "root",
    group	=> "_cups",
    mode	=> "0644",
    notify      => Service["cupsd"],
    source      => "puppet:///modules/cups_sane/LaserJet.ppd",
  }

}
