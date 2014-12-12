# Role: client
class fogstore::roles::client (
  $add_repo        = $fogstore::params::add_repo,
  $admin_password  = $fogstore::params::admin_password,
  $client_ca       = $fogstore::params::client_ca,
  $credential      = $fogstore::params::cred_cert,
  $cred_key        = $fogstore::params::cred_key,
  $cred_password   = $fogstore::params::cred_password,
  $dir_ca          = $fogstore::params::dir_ca,
  $dir_host        = $fogstore::params::dir_host,
  $dir_port        = $fogstore::params::dir_port,
  $dir_protocol    = $fogstore::params::dir_protocol,
  $manage_ssl      = $fogstore::params::manage_ssl,
  $mounts          = $fogstore::params::mounts,
  $mrc_ca          = $fogstore::params::mrc_ca,
  $osd_ca          = $fogstore::params::osd_ca,
  $ssl_source_dir  = $fogstore::params::ssl_source_dir,
  $volumes         = $fogstore::params::volumes,
) inherits fogstore::params {

  include ::fogstore::params

  if $manage_ssl {
    Fogstore::Ssl::Credential <||> ->
    Xtreemfs::Volume <||> ->
    Xtreemfs::Mount <||>

    ::fogstore::ssl::credential {'client':
      client_ca       => $client_ca,
      cred_cert       => $credential,
      cred_key        => $cred_key,
      cred_password   => $cred_password,
      destination_dir => $fogstore::params::cred_location,
      dir_ca          => $dir_ca,
      mrc_ca          => $mrc_ca,
      osd_ca          => $osd_ca,
      role            => 'client',
      ssl_source_dir  => $ssl_source_dir,
    }
  } else {
    Xtreemfs::Volume <||> ->
    Xtreemfs::Mount <||>
  }

  if $add_repo {
    # TODO, see wavesoftware/puppet-xtreemfs#16
  }

  $defaults = {
    dir_host              => $dir_host,
    dir_port              => $dir_port,
    dir_protocol          => $dir_protocol,
    options               => {
      'admin_password'    => $admin_password,
      'pkcs12-file-path'  => "${::fogstore::params::cred_location}/client.p12",
      'pkcs12-passphrase' => $cred_password,
    }
  }

  create_resources(
    xtreemfs::volume,
    $volumes,
    $defaults
  )
  #create_resources(
  #  xtreemfs::mount,
  #  $mounts,
  #  $defaults
  #)

}
