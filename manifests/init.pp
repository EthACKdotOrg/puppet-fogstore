class fogstore(
  $cred_password,
  $role,
  $ssl_source_dir,
  $trusted_password,
  $add_repo       = true,
  $apt_key        = $fogstore::params::apt_key,
  $apt_key_src    = "${source}/Release.key",
  $cred_format    = $fogstore::params::cred_format,
  $dir_service    = $fogstore::params::dir_service,
  $manage_ssl     = true,
  $properties     = {},
  $object_dir     = undef,
  $release        = '',
  $repos          = './',
  $pkg_source     = false,
  $trusted_format = $fogstore::params::trusted_format,
) inherits fogstore::params {

  if $pkg_source {
    $_repository = false
    ::apt::source {'xtreemfs':
      ensure      => present,
      include_src => false,
      key         => $apt_key,
      key_source  => $apt_key_src,
      location    => $pkg_source,
      release     => $release,
      repos       => $repos,
    }
  } else {
    $_repository = $add_repository,
  }
  if $role ~ /osd|mrc|dir/ and $manage_ssl {
    file {$::fogstore::params::trust_location:
      ensure  => directory,
      group   => 'xtreemfs',
      mode    => '0750',
      owner   => 'root',
      require => Anchor[$::xtreemfs::internal::workflow::package],
    }
  }


  class {"::fogstore::roles::${role}":
    add_repo         => $_repository,
    cred_format      => $cred_format,
    cred_password    => $cred_password,
    object_dir       => $object_dir,
    properties       => $properties,
    ssl_source_dir   => $ssl_source_dir,
    trusted_format   => $trusted_format,
    trusted_password => $trusted_password,
  }

}
