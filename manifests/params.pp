# Parameter class
class fogstore::params (
  $add_repo         = true,
  $admin_password   = '',
  $apt_key          = '07D6EA4F2FA7E736',
  $apt_key_name     = '/Release.key',
  $client_ca        = '',
  $cred_cert        = '',
  $cred_certs       = {},
  $cred_format      = 'pkcs12',
  $cred_key         = '',
  $cred_keys        = {},
  $cred_password    = '',
  $dir_ca           = '',
  $dir_jks_password = '',
  $dir_host         = 'localhost',
  $dir_port         = '32636',
  $dir_protocol     = 'pbrpcs',
  $manage_ssl       = true,
  $mounts           = {},
  $mrc_ca           = '',
  $mrc_jks_password = '',
  $object_dir       = undef,
  $osd_ca           = '',
  $osd_jks_password = '',
  $properties       = {},
  $release          = '',
  $repos            = './',
  $pkg_source       = '',
  $ssl_source_dir   = '',
  $trusted_format   = 'jks',
  $trusted          = 'trusted.jks',
  $volumes          = {},
) {

  $apt_key_src = "${pkg_source}/${apt_key_name}"

  $cred_location = '/etc/ssl/certs'

  $min_pwd_length = 12
  $max_pwd_length = 64

  # where we put the credentials and trust stores
  $trust_location = '/etc/xos/xtreemfs/truststore'
}
