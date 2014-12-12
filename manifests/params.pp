# Parameter class
class fogstore::params (
  $add_repo         = true,
  $admin_password   = '',
  $apt_key          = '07D6EA4F2FA7E736',
  $apt_key_name     = '/Release.key',
  $client_ca        = false,
  $cred_cert        = false,
  $cred_certs       = {},
  $cred_format      = 'pkcs12',
  $cred_key         = false,
  $cred_keys        = {},
  $cred_password    = '',
  $dir_ca           = false,
  $dir_jks_password = '',
  $dir_host         = undef,
  $dir_port         = undef,
  $dir_protocol     = undef,
  $manage_ssl       = true,
  $mounts           = {},
  $mrc_ca           = false,
  $mrc_jks_password = '',
  $object_dir       = undef,
  $osd_ca           = false,
  $osd_jks_password = '',
  $properties       = {},
  $release          = '',
  $repos            = './',
  $pkg_source       = false,
  $ssl_source_dir   = '',
  $trusted_format   = 'jks',
  $trusted          = 'trusted.jks',
  $volumes          = {},
) {

  $apt_key_src = "${pkg_source}/${apt_key_name}"

  $cred_location = '/etc/ssl/certs'

  # where we put the credentials and trust stores
  $trust_location = '/etc/xos/xtreemfs/truststore'
}
