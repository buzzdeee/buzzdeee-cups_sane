# private class, do not use directly
# the parameters that drive this module

class cups_sane::params {
  case $::osfamily {
    'OpenBSD': {
      $packages = [ 'sane-backends', 'hpaio', 'cups', 'hpcups', ]
      $service_provider = undef
    }
    'Suse': {
      $packages = [ 'cups', 'cups-libs', 'cups-client', ]
      $service_provider = 'systemd'
    }
    'Debian': {
      $packages = [ 'cups', 'sane', ]
      $service_provider = undef
    }
  }

  $packages_ensure = 'installed'

  $is_cups_client = 'false'
  $is_cups_server = 'false'
  $remote_cups_server = 'cups'

}
