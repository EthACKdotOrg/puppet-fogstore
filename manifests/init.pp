# == Class fogstore
#
# Entry point for xtreemfs/openssl/jks wrappers
#
# == Parameters
# === Mandatory
#
# [*cred_password*]
#       Password for credential container.
#
# [*role*]
#       Node role. Accepted:
#       client, dir, mrc, osd
#
# [*ssl_source_dir*]
#       Source directory for SSL certificates.
#       Might be either on the filesystel (file:///…)
#       or a puppet resource (puppet:///modules/…)
#
# [*trusted_password*]
#       Password for trusted container.
#
# === Optional
#
# [*add_repo*]
#       Tell the module to add XtreemFS repository
#       and related GPG key.
#
# [*apt_key*]
#       In case you want to add your own repository, provide
#       APT key.
#
# [*apt_key_src*]
#       In case you want to add your own repository, provide
#       its APT key source
#
# [*cred_format*]
#       Credential container format.
#
# [*dir_service*]
#       Directory service address
#
# [*manage_ssl*]
#       Should fogstore manage your SSL certificate?
#       If so, it will create the necessary credential and
#       trusted containers.
#
# [*properties*]
#       Xtreemfs configuration hash as listed in documentation:
#       http://xtreemfs.org/xtfs-guide-1.5/index.html#tth_sEc3.2.6
#
# [*object_dir*]
#       Xtreemfs object destination. Should be some RAID[156] volume
#       for better security.
#
# [*release*]
#       APT repository related "release" field
#
# [*repos*]
#       APT repository path
#
# [*pkg_source*]
#       Your own APT repository for XtreemFS packages
#       Note: if you sed $add_repo to false and set
#       pkg_source to some value, it *will* add your repository.
#       Setting $add_repo to "true" and setting your own custom repository
#       will only add your repository.
#
# [*trusted_format*]
#       Trusted store container format.
#
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

  if $role !~ /client|dir|mrc|osd/ {
    fail "Fogstore: unknown node role: ${role}"
  }

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
