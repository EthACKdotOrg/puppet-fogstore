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
#       client, dir, introducer, mrc, osd
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
# [*client_ca*]
#       Client CA file name.
#
# [*client_jks_password*]
#       Client JKS truststore password.
#
# [*cred_cert*]
#       Credential certificate file name.
#
# [*cred_certs*]
#       Credential certificate file names as a hash.
#       Mostly used for an Introducer. Hash format:
#       { role => filename}
#
# [*cred_format*]
#       Credential container format.
#
# [*cred_key*]
#       Credential private key file name.
#
# [*cred_keys*]
#       Credential private key file names as a hash.
#       Mostly used for an Introducer. Hash format:
#       { role => filename}
#
# [*dir_ca*]
#       Dir CA file name.
#
# [*dir_jks_password*]
#       Dir JKS truststore password.
#
# [*dir_service*]
#       Directory service address.
#
# [*manage_ssl*]
#       Should fogstore manage your SSL certificate?
#       If so, it will create the necessary credential and
#       trusted containers.
#
# [*mrc_ca*]
#       MRC CA file name.
#
# [*mrc_jks_password*]
#       MRC JKS truststore password.
#
# [*object_dir*]
#       Xtreemfs object destination. Should be some RAID[156] volume
#       for better security.
#
# [*osd_ca*]
#       OSD CA file name.
#
# [*osd_jks_password*]
#       OSD JKS truststore password.
#
# [*properties*]
#       Xtreemfs configuration hash as listed in documentation:
#       http://xtreemfs.org/xtfs-guide-1.5/index.html#tth_sEc3.2.6
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
  $add_repo            = true,
  $apt_key             = $fogstore::params::apt_key,
  $apt_key_src         = "${source}/Release.key",
  $client_ca           = false,
  $client_jks_password = false,
  $cred_cert           = false,
  $cred_certs          = {},
  $cred_format         = $fogstore::params::cred_format,
  $cred_key            = false,
  $cred_keys           = {},
  $dir_ca              = false,
  $dir_jks_password    = false,
  $dir_service         = $fogstore::params::dir_service,
  $manage_ssl          = true,
  $mrc_ca              = false,
  $mrc_jks_password    = false,
  $object_dir          = undef,
  $osd_ca              = false,
  $osd_jks_password    = false,
  $properties          = {},
  $release             = '',
  $repos               = './',
  $pkg_source          = false,
  $trusted_format      = $fogstore::params::trusted_format,
) inherits fogstore::params {

  if $role !~ /client|dir|introducer|mrc|osd/ {
    fail "Fogstore: unknown node role: ${role}"
  }

  if $manage_ssl and (
    !$client_ca or
    !$client_jks_password or
    (!$cred_cert and size($cred_certs) == 0) or
    (!$cred_key and size($cred_keys) == 0) or
    !$dir_ca or
    !$dir_jks_password or
    !$mrc_ca or
    !$mrc_jks_password or
    !$osd_ca or
    !$osd_jks_password
  ) {
    fail 'Fogstore: we need all CA and JKS password if $manage_ssl is TRUE'
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

  if $role ~ /osd|mrc|dir|introducer/ and $manage_ssl {
    file {$::fogstore::params::trust_location:
      ensure  => directory,
      group   => 'xtreemfs',
      mode    => '0750',
      owner   => 'root',
      require => Anchor[$::xtreemfs::internal::workflow::package],
    }
  }

  if ($role == 'introducer' {
    class {"::fogstore::roles::mrc":
      add_repo         => $_repository,
      cred_format      => $cred_format,
      cred_password    => $cred_password,
      object_dir       => $object_dir,
      properties       => $properties,
      ssl_source_dir   => $ssl_source_dir,
      trusted_format   => $trusted_format,
      trusted_password => $trusted_password,
    }
    class {"::fogstore::roles::dir":
      add_repo         => $_repository,
      cred_format      => $cred_format,
      cred_password    => $cred_password,
      object_dir       => $object_dir,
      properties       => $properties,
      ssl_source_dir   => $ssl_source_dir,
      trusted_format   => $trusted_format,
      trusted_password => $trusted_password,
    }
  } else {
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
}
