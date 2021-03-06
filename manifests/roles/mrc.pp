# == Role: MRC
#
# Wrapper for xtreemfs::role::metadata
# Please refer to its documentation
#
# === Additional settings:
#
class fogstore::roles::mrc(
  $add_repo         = $fogstore::params::add_repo,
  $admin_password   = $fogstore::params::admin_password,
  $client_ca        = $fogstore::params::client_ca,
  $cred_format      = $fogstore::params::cred_format,
  $cred_password    = $fogstore::params::cred_password,
  $credential       = $fogstore::params::cred_cert,
  $dir_ca           = $fogstore::params::mrc_ca,
  $dir_host         = $fogstore::params::dir_host,
  $dir_port         = $fogstore::params::dir_port,
  $dir_protocol     = $fogstore::params::dir_protocol,
  $manage_jks       = $fogstore::params::manage_ssl,
  $properties       = $fogstore::params::properties,
  $ssl_source_dir   = $fogstore::params::ssl_source_dir,
  $trust_store      = $fogstore::params::trust_store,
  $trusted_format   = $fogstore::params::trusted_format,
  $trusted_password = $fogstore::params::dir_jks_password,
) inherits fogstore::params {

  validate_string($admin_password)
  validate_slength($admin_password, 64, 12)
  validate_bool($add_repo)


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
      "${fogstore::params::trust_location}/${trust_store}",
    'ssl.trusted_certs.container' =>
      $trusted_format,
    'ssl.trusted_certs.pw' =>
      $trusted_password,
    'authentication_provider' =>
      'org.xtreemfs.common.auth.SimpleX509AuthProvider',
    'admin_password' => $admin_password,
  }

  if ($manage_jks) {
    ::fogstore::ssl::trusted {'mrc':
      client_ca        => $client_ca,
      mrc_jks_password => $trusted_password,
      dir_ca           => $dir_ca,
      ssl_source_dir   => $ssl_source_dir,
    }
  }

  class {'::xtreemfs::role::metadata':
    add_repo     => $add_repo,
    dir_host     => $dir_host,
    #dir_port     => $dir_port,
    dir_protocol => $dir_protocol,
    properties   => merge($local_properties, $properties),
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
