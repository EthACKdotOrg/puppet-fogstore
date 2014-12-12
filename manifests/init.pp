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
  $add_repo            = true,
  $apt_key             = $fogstore::params::apt_key,
  $apt_key_src         = "${pkg_source}/Release.key",
  $client_ca           = false,
  $cred_cert           = false,
  $cred_certs          = {},
  $cred_format         = $fogstore::params::cred_format,
  $cred_key            = false,
  $cred_keys           = {},
  $dir_ca              = false,
  $dir_jks_password    = false,
  $dir_host            = $fogstore::params::dir_host,
  $dir_poer            = $fogstore::params::dir_port,
  $dir_protocol        = $fogstore::params::dir_protocol,
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
  $trusted             = "${role}.jks",
) inherits fogstore::params {

  if $role !~ /client|dir|introducer|mrc|osd/ {
    fail "Fogstore: unknown node role: ${role}"
  }

  if $manage_ssl {
    if (!$cred_cert or $cred_cert == '') and $cred_certs == {} {
      fail 'Need credential certificate'
    }
    case $role {
      'client': {
        # client needs dir, mrc, osd in its p12
        if !$dir_ca or !$mrc_ca or !$osd_ca {
          fail 'Needs dir, mrc and osd CAs for client'
        }
        ::fogstore::ssl::credential{'client': }
      }
      'dir': {
        # dir needs client, mrc, osd
        if !$client_ca or !$mrc_ca or !$osd_ca {
          fail 'Needs client, mrc and osd CAs for dir'
        }
        if !$dir_jks_password {
          fail 'Needs dir_jks_password for dir'
        }
        $trusted_password = $dir_jks_password
        ::fogstore::ssl::credential{'dir': }
      }
      'introducer': {
        # dir part needs client, mrc, osd
        if !$client_ca or !$mrc_ca or !$osd_ca {
          fail 'Needs client, mrc and osd CAs for dir (introducer)'
        }
        if !$dir_jks_password {
          fail 'Need dir_jks_password for dir (introducer)'
        }
        ::fogstore::ssl::credential{'dir': }

        # mrc part needs client, dir
        if !$client_ca or !$dir_ca {
          fail 'Needs client and dir CAs for mrc (introducer)'
        }
        if !$mrc_jks_password {
          fail 'Need mrc_jks_password for mrc (introducer)'
        }
        ::fogstore::ssl::credential{'mrc': }

      }
      'mrc': {
        # mrc needs client, dir
        if !$client_ca or !$dir_ca {
          fail 'Needs client and dir CAs for mrc'
        }
        if !$mrc_jks_password {
          fail 'Need mrc_jks_password for mrc'
        }
        $trusted_password = $mrc_jks_password
        ::fogstore::ssl::credential{'mrc': }
      }
      'osd': {
        # osd needs client, dir
        if !$client_ca or !$dir_ca {
          fail 'Needs client and dir CAs for osd'
        }
        if !$osd_jks_password {
          fail 'Need osd_jks_password for osd'
        }
        ::fogstore::ssl::credential{'osd': }
        $trusted_password = $osd_jks_password
      }
      default : { fail "Unknown role: ${role}" }
    }
  }

  include ::xtreemfs::internal::workflow

  class {'::apt':
    purge_sources_list   => true,
    purge_sources_list_d => true,
    purge_preferences_d  => true,
  }
  ::apt::conf {'ignore-suggests':
    content => 'APT::Install-Suggests "0";',
  }
  ::apt::pin {'nox':
    packages => 'xserver-xorg-core',
    origin   => 'Debian',
    priority => '-1',
  }

  if $pkg_source and $pkg_source != '' {
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
    $_repository = $add_repo
  }

  if $role =~ /(osd|mrc|dir|introducer)/ and $manage_ssl {
    file {$::fogstore::params::trust_location:
      ensure  => directory,
      group   => 'xtreemfs',
      mode    => '0750',
      owner   => 'root',
      require => Anchor[$::xtreemfs::internal::workflow::packages],
    }
    include ::fogstore::ssl::trusted
  }

  if $role == 'introducer' {
    class {'::fogstore::roles::mrc':
      add_repo         => $_repository,
      cred_format      => $cred_format,
      cred_password    => $cred_password,
      object_dir       => $object_dir,
      properties       => $properties,
      ssl_source_dir   => $ssl_source_dir,
      trusted_format   => $trusted_format,
      trusted_password => $mrc_jks_password,
    }
    class {'::fogstore::roles::dir':
      add_repo         => $_repository,
      cred_format      => $cred_format,
      cred_password    => $cred_password,
      object_dir       => $object_dir,
      properties       => $properties,
      ssl_source_dir   => $ssl_source_dir,
      trusted_format   => $trusted_format,
      trusted_password => $dir_jks_password,
    }
  } else {
    class {"::fogstore::roles::${role}":
      add_repo => $_repository,
    }
  }
}
