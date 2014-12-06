class fogstore::params {

  # default APT repository key
  $apt_key = '07D6EA4F2FA7E736'

  # used for ssl.service_creds.container
  $cred_format = 'pkcs12'

  # default dir service
  $dir_service = 'localhost'

  # used for ssl.trusted_certs.container
  $trusted_format = 'jks'

  # where we put the credentials and trust stores
  $trusted_location = '/etc/xos/xtreemfs/truststore'
}
