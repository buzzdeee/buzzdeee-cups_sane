class cups_sane::install (
  $packages,
  $packages_ensure,
) {

  package { $packages:
    ensure => $packages_ensure,
  }  

}
