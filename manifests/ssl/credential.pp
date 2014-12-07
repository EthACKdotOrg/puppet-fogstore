# == Definition: fogstore::ssl::credential
#
# manage XtreemFS credential PKCS12
#
# == Parameters
# === Optional
#
# [*client_ca*]
#       Client CA file name.
#
# [*cred_cert*]
#       Credential Certificate file name.
#
# [*cred_key*]
#       Credential Private key file name.
#
# [*cred_password*]
#       Password for generated PKCS12 file.
#
# [*destination_dir*]
#       Destination directory for generated PKCS12 file.
#
# [*dir_ca*]
#       Dir CA file name.
#
# [*mrc_ca*]
#       MRC CA file name.
#
# [*osd_ca*]
#       OSD CA file name.
#
# [*ssl_source_dir*]
#       Source directory for SSL certificates
#
define fogstore::ssl::credential(
  $client_ca       = $fogstore::client_ca,
  $cred_cert       = $fogstore::cred_cert,
  $cred_key        = $fogstore::cred_key,
  $cred_password   = $fogstore::cred_password,
  $destination_dir = $fogstore::params::cred_location,
  $dir_ca          = $fogstore::dir_ca,
  $mrc_ca          = $fogstore::mrc_ca,
  $osd_ca          = $fogstore::osd_ca,
  $ssl_source_dir  = $fogstore::ssl_source_dir,
) inherits fogstore::params {
  file {"/etc/ssl/certs/xtreemfs-credentials-${name}.pem":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
    source => [
      "${ssl_source_dir}/${cred_cert}",
      "${ssl_source_dir}/${client_ca}",
      "${ssl_source_dir}/${dir_ca}",
      "${ssl_source_dir}/${mrc_ca}",
      "${ssl_source_dir}/${osd_ca}",
      ],
  }->
  ::openssl::export::pkcs12 {"xtreemfs-credentials-${name}":
    ensure   => present,
    basedir  => $destination_dir,
    cert     => '/etc/ssl/certs/xtreemfs-credentials.pem',
    pkey     => "${ssl_source_dir}/${cred_key}",
    out_pass => $cred_password,
  }
}
