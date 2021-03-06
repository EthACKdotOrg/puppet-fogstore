# Role: client
class fogstore::roles::client (
  $add_repo        = $fogstore::params::add_repo,
  $admin_password  = $fogstore::params::admin_password,
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
  include ::fogstore::user

  $min = $fogstore::params::min_pwd_length
  $max = $fogstore::params::max_pwd_length

  validate_string($admin_password)
  validate_string($dir_protocol)
  validate_string($credential)
  validate_string($cred_key)
  validate_string($cred_password)

  validate_bool($add_repo)
  validate_bool($manage_ssl)

  validate_slength($admin_password, $max, $min)
  validate_slength($cred_password, $max, $min)

  if !is_integer($dir_port) {
    fail "${dir_port} doesn't look like an integer"
  }

  if !is_domain_name($dir_host) {
    fail "${dir_host} doesn't look like a valide name"
  }

  if !is_hash($volumes) {
    fail 'Volumes need to ba a hash'
  }
  if !is_hash($mounts) {
    fail 'Mounts need to ba a hash'
  }

  if $credential == '' {
    fail 'Credential seems to be an empty string'
  }
  if $cred_key == '' {
    fail 'Cred_key seems to be an empty string'
  }
  if $cred_password == '' {
    fail 'Cred_password seems to be an empty string'
  }

  if $manage_ssl {
    Fogstore::Ssl::Credential <||> ->
    Xtreemfs::Volume <||> ->
    Xtreemfs::Mount <||>

    ::fogstore::ssl::credential {'client':
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

  class {'::xtreemfs::settings':
    add_repo => $add_repo,
  }
  if $add_repo {
    include ::xtreemfs::internal::repo
  }

  $defaults = {
    dir_host              => $dir_host,
    #dir_port              => $dir_port,
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
