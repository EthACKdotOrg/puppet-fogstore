class fogstore::params {

  # default APT repository key
  $apt_key = '07D6EA4F2FA7E736'

  # used for ssl.service_creds.container
  $cred_format = 'pkcs12'

  # credential location
  $cred_location = '/etc/ssl/certs'

  # default dir service
  $dir_host     = 'localhost'
  $dir_port     = undef
  $dir_protocol = undef

  # used for ssl.trusted_certs.container
  $trusted_format = 'jks'

  # where we put the credentials and trust stores
  $trust_location = '/etc/xos/xtreemfs/truststore'
}
