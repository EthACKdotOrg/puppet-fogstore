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
  $client_ca       = $fogstore::params::client_ca,
  $cred_cert       = $fogstore::params::cred_cert,
  $cred_key        = $fogstore::params::cred_key,
  $cred_password   = $fogstore::params::cred_password,
  $destination_dir = $fogstore::params::cred_location,
  $dir_ca          = $fogstore::params::dir_ca,
  $mrc_ca          = $fogstore::params::mrc_ca,
  $osd_ca          = $fogstore::params::osd_ca,
  $role            = $title,
  $ssl_source_dir  = $fogstore::params::ssl_source_dir,
) {

  case $role {
    client: {
      $source = [
        "${ssl_source_dir}/${cred_cert}",
        "${ssl_source_dir}/${dir_ca}",
        "${ssl_source_dir}/${mrc_ca}",
        "${ssl_source_dir}/${osd_ca}",
      ]
    }
    dir: {
      $source = [
        "${ssl_source_dir}/${cred_cert}",
        "${ssl_source_dir}/${client_ca}",
        "${ssl_source_dir}/${mrc_ca}",
        "${ssl_source_dir}/${osd_ca}",
      ]
    }
    mrc: {
      $source = [
        "${ssl_source_dir}/${cred_cert}",
        "${ssl_source_dir}/${client_ca}",
        "${ssl_source_dir}/${dir_ca}",
        "${ssl_source_dir}/${osd_ca}",
      ]
    }
    osd: {
      $source = [
        "${ssl_source_dir}/${cred_cert}",
        "${ssl_source_dir}/${client_ca}",
        "${ssl_source_dir}/${dir_ca}",
        "${ssl_source_dir}/${mrc_ca}",
      ]
    }
    default: { fail "Unknown role ${role}"}
  }

  file {"/etc/ssl/certs/xtreemfs-credentials-${name}.pem":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => $source,
  }->
  ::openssl::export::pkcs12 {"xtreemfs-credentials-${name}":
    ensure   => present,
    basedir  => $destination_dir,
    cert     => "/etc/ssl/certs/xtreemfs-credentials-${name}.pem",
    pkey     => "${ssl_source_dir}/${cred_key}",
    out_pass => $cred_password,
  }
}
