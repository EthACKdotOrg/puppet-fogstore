# == Role: OSD (aka storage)
#
# Wrapper for xtreemfs::role::storage
# Please refer to its documentation
#
# === Additional settings:
#
# [*cred_format*]
#       Set creditial file format, default: pkcs12
#
# [*credential*]
#       Set credential certificate name (source/destination)
#
# [*ssl_source_dir*]
#       Set certificates source directory. Might be a puppet resource
#
# [*trusted_format*]
#       Set trust store format, default: jks
#
# [*trusted*]
#       Set trust store name (source/destination)
#
# NOTE: $properties might override the $local_properties!
class fogstore::roles::osd(
  $add_repo         = $fogstore::params::add_repo,
  $client_ca        = $fogstore::params::client_ca,
  $cred_format      = $fogstore::params::cred_format,
  $cred_password    = $fogstore::params::cred_password,
  $credential       = $fogstore::params::cred_cert,
  $dir_ca           = $fogstore::params::dir_ca,
  $dir_host         = $fogstore::params::dir_host,
  $dir_port         = $fogstore::params::dir_port,
  $dir_protocol     = $fogstore::params::dir_protocol,
  $manage_jks       = $fogstore::params::manage_ssl,
  $object_dir       = $fogstore::params::object_dir,
  $properties       = $fogstore::params::properties,
  $ssl_source_dir   = $fogstore::params::ssl_source_dir,
  $trusted          = $fogstore::params::trusted,
  $trusted_format   = $fogstore::params::trusted_format,
  $trusted_password = $fogstore::params::osd_jks_password,
) inherits fogstore::params {

  include ::fogstore::user

  if $client_ca == '' {
    fail 'Need client_ca for OSD role'
  }
  if $dir_ca == '' {
    fail 'Need dir_ca for OSD role'
  }

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
    ::fogstore::ssl::trusted {'osd':
      client_ca        => $client_ca,
      dir_ca           => $dir_ca,
      osd_jks_password => $trusted_password,
      ssl_source_dir   => $ssl_source_dir,
    }
  }

  class {'::xtreemfs::role::storage':
    add_repo     => $add_repo,
    dir_host     => $dir_host,
    dir_port     => $dir_port,
    dir_protocol => $dir_protocol,
    object_dir   => $object_dir,
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
