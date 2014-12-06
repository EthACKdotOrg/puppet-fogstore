define fogstore::ssl::credential(
  $client_ca,
  $cred_cert,
  $cred_key,
  $destination_dir = '/etc/ssl/certs',
  $dir_ca,
  $mrc_ca,
  $osd_ca,
  $pkcs_password,
) {
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
