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

  if !$cred_cert or $cred_cert == '' or
      !$cred_key or $cred_key == '' or
      !$cred_password or $cred_password == '' {
        fail 'Need cred_cert, cred_key and cred_password'
  }

  case $role {
    client: {
      if !$dir_ca or $dir_ca == '' or
          !$mrc_ca or $mrc_ca == '' or
          !$osd_ca or $osd_ca == '' {
            fail 'Need dir_ca, mrc_ca and osd_ca'
      }
      $source = [
        "${ssl_source_dir}/${cred_cert}",
        "${ssl_source_dir}/${dir_ca}",
        "${ssl_source_dir}/${mrc_ca}",
        "${ssl_source_dir}/${osd_ca}",
      ]
    }
    dir: {
      if !$client_ca or $client_ca == '' or
          !$mrc_ca or $mrc_ca == '' or
          !$osd_ca or $osd_ca == '' {
            fail 'Need dir_ca, mrc_ca and osd_ca'
      }
      $source = [
        "${ssl_source_dir}/${cred_cert}",
        "${ssl_source_dir}/${client_ca}",
        "${ssl_source_dir}/${mrc_ca}",
        "${ssl_source_dir}/${osd_ca}",
      ]
    }
    mrc: {
      if !$client_ca or $client_ca == '' or
          !$dir_ca or $dir_ca == ''  {
            fail 'Need dir_ca and dir_ca'
      }
      $source = [
        "${ssl_source_dir}/${cred_cert}",
        "${ssl_source_dir}/${client_ca}",
        "${ssl_source_dir}/${dir_ca}",
      ]
    }
    osd: {
      if !$client_ca or $client_ca == '' or
          !$dir_ca or $dir_ca == '' {
            fail 'Need client and dir_ca'
      }
      $source = [
        "${ssl_source_dir}/${cred_cert}",
        "${ssl_source_dir}/${client_ca}",
        "${ssl_source_dir}/${dir_ca}",
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
