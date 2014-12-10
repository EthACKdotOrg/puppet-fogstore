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
  $add_repo       = $fogstore::add_repo,
  $cred_format    = $fogstore::cred_format,
  $credential     = undef,
  $cred_password  = $fogstore::cred_password,
  $dir_service    = $fogstore::params::dir_service,
  $object_dir     = undef,
  $properties     = {},
  $ssl_source_dir = $fogstore::ssl_source_dir,
  $trusted        = undef,
  $trusted_format = $fogstore::trusted_format,
  $trusted_password = $fogstore::osd_jks_password,
) inherits fogstore::params {

  # Set SSL configuration by default
  $local_properties = {
    'ssl.enabled' =>
      'true',
    'ssl.service_creds' =>
      "${fogstore::params::trust_location}/${credential}",
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

  class {'::xtreemfs::role::storage':
    add_repo    => $add_repo,
    dir_service => $::fogstore::dir_service,
    object_dir  => $object_dir,
    properties  => merge($local_properties, $properties),
  }

  file {"${trust_location}/${credential}":
    ensure  => file,
    group   => 'xtreemfs',
    mode    => '0640',
    notify  => Anchor[$::xtreemfs::internal::workflow::configure],
    owner   => 'root',
    source  => "{$ssl_source_dir}/${credential}",
  }
}
