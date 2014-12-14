# == Role: DIR
#
# Wrapper for xtreemfs::role::storage
# Please refer to its documentation
#
# === Additional settings:
#
class fogstore::roles::dir(
  $add_repo         = $fogstore::params::add_repo,
  $client_ca        = $fogstore::params::client_ca,
  $cred_format      = $fogstore::params::cred_format,
  $cred_password    = $fogstore::params::cred_password,
  $credential       = $fogstore::params::cred_cert,
  $manage_jks       = $fogstore::params::manage_ssl,
  $mrc_ca           = $fogstore::params::mrc_ca,
  $osd_ca           = $fogstore::params::osd_ca,
  $properties       = $fogstore::params::properties,
  $ssl_source_dir   = $fogstore::params::ssl_source_dir,
  $trusted          = $fogstore::params::trusted,
  $trusted_format   = $fogstore::params::trusted_format,
  $trusted_password = $fogstore::params::dir_jks_password,
) inherits fogstore::params {

  include ::fogstore::user

  # Set SSL configuration by default
  $local_properties = {
    'ssl.enabled' =>
      true,
    'ssl.service_creds' =>
      "${fogstore::params::cred_location}/${credential}",
    'ssl.service_creds.container' =>
      $cred_format,
    'ssl.service_creds.pw' =>
      $cred_password,
    'ssl.trusted_certs' =>
      "${fogstore::params::trust_location}/${trusted}",
    'ssl.trusted_certs.container' =>
      $trusted_format,
    'ssl.trusted_certs.pw' =>
      $trusted_password,
  }

  if ($manage_jks) {
    ::fogstore::ssl::trusted {'dir':
      client_ca        => $client_ca,
      dir_jks_password => $trusted_password,
      mrc_ca           => $mrc_ca,
      osd_ca           => $osd_ca,
      ssl_source_dir   => $ssl_source_dir,
    }
  }

  class {'::xtreemfs::role::directory':
    add_repo   => $add_repo,
    properties => merge($local_properties, $properties),
  }

  file {"${fogstore::params::cred_location}/${credential}":
    ensure => file,
    group  => 'xtreemfs',
    mode   => '0640',
    notify => Anchor[$::xtreemfs::internal::workflow::configure],
    owner  => 'root',
    source => "${ssl_source_dir}/${credential}",
  }
}
