class cups_sane::cups::client::service (
  $service_provider,
){

  $services = [ 'cupsd.service', 'cups.path', 'cups.service', 'cups.socket' ]

  service { $services:
    ensure => 'stopped',
    enable => 'false',
    provider => $service_provider,
  }

}
