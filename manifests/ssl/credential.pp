# == Definition: fogstore::ssl::credential
#
# manage XtreemFS credential PKCS12
#
# == Parameters
# === Mandatory
#
# [*client_ca*]
#       Client CA file.
#
# [*cred_cert*]
#       Credential Certificate file.
#
# [*cred_key*]
#       Credential Private key file.
#
# [*dir_ca*]
#       Dir CA file.
#
# [*mrc_ca*]
#       MRC CA file.
#
# [*osd_ca*]
#       OSD CA file.
#
# [*pkcs_password*]
#       Password for generated PKCS12 file.
#
# === Optional
#
# [*destination_dir*]
#       Destination directory for generated PKCS12 file.
define fogstore::ssl::credential(
  $client_ca,
  $cred_cert,
  $cred_key,
  $dir_ca,
  $mrc_ca,
  $osd_ca,
  $pkcs_password,
  $destination_dir = $fogstore::params::cred_location,
) inherits fogstore::params {
  file {"/etc/ssl/certs/xtreemfs-credentials-${name}.pem":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644'
    source => [
      $cred_cert,
      $client_ca,
      $dir_ca,
      $mrc_ca,
      $osd_ca,
      ],
  }->
  ::openssl::export::pkcs12 {"xtreemfs-credentials-${name}":
    ensure   => present,
    basedir  => $destination_dir,
    cert     => '/etc/ssl/certs/xtreemfs-credentials.pem',
    pkey     => $cred_key,
    out_pass => $pkcs_password,
  }
}
