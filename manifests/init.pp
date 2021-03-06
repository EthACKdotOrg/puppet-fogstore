# == Class fogstore
#
# Entry point for xtreemfs/openssl/jks wrappers
#
# == Parameters
# === Mandatory
#
# [*cred_password*]
#       Password for credential container.
## OR
# [*cred_passwords*]
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
  $role,
  $ssl_source_dir,
  $add_repo            = $fogstore::params::add_repo,
  $admin_password      = $fogstore::params::admin_password,
  $apt_key             = $fogstore::params::apt_key,
  $apt_key_src         = $fogstore::params::apt_key_src,
  $client_ca           = $fogstore::params::client_ca,
  $cred_cert           = $fogstore::params::cred_cert,
  $cred_certs          = $fogstore::params::cred_certs,
  $cred_format         = $fogstore::params::cred_format,
  $cred_key            = $fogstore::params::cred_key,
  $cred_keys           = $fogstore::params::cred_keys,
  $cred_password       = false,
  $cred_passwords      = {},
  $dir_ca              = $fogstore::params::dir_ca,
  $dir_jks_password    = $fogstore::params::dir_jks_password,
  $dir_host            = $fogstore::params::dir_host,
  $dir_port            = $fogstore::params::dir_port,
  $dir_protocol        = $fogstore::params::dir_protocol,
  $manage_ssl          = $fogstore::params::manage_ssl,
  $mounts              = $fogstore::params::mounts,
  $mrc_ca              = $fogstore::params::mrc_ca,
  $mrc_jks_password    = $fogstore::params::mrc_jks_password,
  $object_dir          = $fogstore::params::object_dir,
  $osd_ca              = $fogstore::params::osd_ca,
  $osd_jks_password    = $fogstore::params::osd_jks_password,
  $properties          = $fogstore::params::properties,
  $release             = $fogstore::params::release,
  $repos               = $fogstore::params::repos,
  $pkg_source          = $fogstore::params::pkg_source,
  $trusted_format      = $fogstore::params::trusted_format,
  $trust_store         = "${role}.jks",
  $volumes             = $fogstore::params::volumes,
) inherits fogstore::params {

  validate_bool($add_repo)


  if $role !~ /client|dir|introducer|mrc|osd/ {
    fail "Fogstore: unknown node role: ${role}"
  }

  if (!$cred_password or $cred_password == '') and ($cred_passwords == {}) {
    fail 'Need either cred_password or cred_passwords!'
  }

  if $manage_ssl {
    if (!$cred_cert or $cred_cert == '') and $cred_certs == {} {
      fail 'Need credential certificate'
    }
    if (!$cred_key or $cred_key == '') and ($cred_keys == {}) {
      fail 'Need either cred_key or cred_keys!'
    }

    Fogstore::Ssl::Credential{
      client_ca       => $client_ca,
      cred_cert       => $cred_cert,
      cred_key        => $cred_key,
      cred_password   => $cred_password,
      destination_dir => $fogstore::params::cred_location,
      dir_ca          => $dir_ca,
      mrc_ca          => $mrc_ca,
      osd_ca          => $osd_ca,
      ssl_source_dir  => $ssl_source_dir,
    }
    case $role {
      'client': {
        # client needs dir, mrc, osd in its p12
        if !$dir_ca or !$mrc_ca or !$osd_ca {
          fail 'Needs dir, mrc and osd CAs for client'
        }
        # client needs admin password
        if (!$admin_password or $admin_password == '') {
          fail 'Need admin_password'
        }
      }
      'dir': {
        # dir needs client, mrc, osd
        if !$client_ca or !$mrc_ca or !$osd_ca {
          fail 'Needs client, mrc and osd CAs for dir'
        }
        if !$dir_jks_password {
          fail 'Needs dir_jks_password for dir'
        }
        # dir needs admin password
        if (!$admin_password or $admin_password == '') {
          fail 'Need admin_password'
        }
        $trusted_password = $dir_jks_password
        ::fogstore::ssl::credential{'dir': }
      }
      'introducer': {
        # dir/mrc need admin password
        if (!$admin_password or $admin_password == '') {
          fail 'Need admin_password'
        }
        # dir part needs client, mrc, osd
        if !$client_ca or !$mrc_ca or !$osd_ca {
          fail 'Needs client, mrc and osd CAs for dir (introducer)'
        }
        if !$dir_jks_password {
          fail 'Need dir_jks_password for dir (introducer)'
        }

        if $cred_certs == {} or $cred_passwords == {} or $cred_keys == {} {
          fail 'Need cred_certs, cred_passwords and cred_keys hash!'
        }

        ::fogstore::ssl::credential{'dir':
          cred_cert     => $cred_certs['dir'],
          cred_key      => $cred_keys['dir'],
          cred_password => $cred_passwords['dir'],
        }

        # mrc part needs client, dir
        if !$client_ca or !$dir_ca {
          fail 'Needs client and dir CAs for mrc (introducer)'
        }
        if !$mrc_jks_password {
          fail 'Need mrc_jks_password for mrc (introducer)'
        }
        ::fogstore::ssl::credential{'mrc':
          cred_cert     => $cred_certs['mrc'],
          cred_key      => $cred_keys['mrc'],
          cred_password => $cred_passwords['mrc'],
        }

      }
      'mrc': {
        # mrc needs client, dir
        if !$client_ca or !$dir_ca {
          fail 'Needs client and dir CAs for mrc'
        }
        if !$mrc_jks_password {
          fail 'Need mrc_jks_password for mrc'
        }
        # mrc needs admin password
        if (!$admin_password or $admin_password == '') {
          fail 'Need admin_password'
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
    purge => {
      'sources.list'   => true,
      'sources.list.d' => true,
      'preferences'    => true,
      'preferences.d'  => true,
    },
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

  case $role {
    'client': {
      class {'::fogstore::roles::client':
        add_repo       => $_repository,
        admin_password => $admin_password,
        credential     => $cred_cert,
        cred_key       => $cred_key,
        cred_password  => $cred_password,
        dir_ca         => $dir_ca,
        dir_host       => $dir_host,
        dir_port       => $dir_port,
        dir_protocol   => $dir_protocol,
        manage_ssl     => $manage_ssl,
        mounts         => $mounts,
        mrc_ca         => $mrc_ca,
        osd_ca         => $osd_ca,
        ssl_source_dir => $ssl_source_dir,
        volumes        => $volumes,
      }
    }
    'dir': {
      class {'::fogstore::roles::dir':
        add_repo         => $_repository,
        admin_password   => $admin_password,
        client_ca        => $client_ca,
        cred_format      => $cred_format,
        cred_password    => $cred_password,
        credential       => $cred_cert,
        mrc_ca           => $mrc_ca,
        osd_ca           => $osd_ca,
        properties       => $properties,
        ssl_source_dir   => $ssl_source_dir,
        trust_store      => $trust_store,
        trusted_format   => $trusted_format,
        trusted_password => $dir_jks_password,
      }
    }
    'introducer': {
      class {'::fogstore::roles::dir':
        add_repo         => $_repository,
        admin_password   => $admin_password,
        client_ca        => $client_ca,
        cred_format      => $cred_format,
        cred_password    => $cred_passwords['dir'],
        credential       => 'dir.p12',
        mrc_ca           => $mrc_ca,
        osd_ca           => $osd_ca,
        properties       => $properties,
        ssl_source_dir   => $ssl_source_dir,
        trust_store      => 'dir.jks',
        trusted_format   => $trusted_format,
        trusted_password => $dir_jks_password,
      }
      class {'::fogstore::roles::mrc':
        add_repo         => $_repository,
        admin_password   => $admin_password,
        client_ca        => $client_ca,
        cred_format      => $cred_format,
        cred_password    => $cred_passwords['mrc'],
        credential       => 'mrc.p12',
        dir_ca           => $dir_ca,
        properties       => $properties,
        ssl_source_dir   => $ssl_source_dir,
        trust_store      => 'mrc.jks',
        trusted_format   => $trusted_format,
        trusted_password => $mrc_jks_password,
      }
    }
    'mrc': {
      class {'::fogstore::roles::mrc':
        add_repo         => $_repository,
        admin_password   => $admin_password,
        client_ca        => $client_ca,
        cred_format      => $cred_format,
        cred_password    => $cred_password,
        credential       => $cred_cert,
        dir_ca           => $dir_ca,
        properties       => $properties,
        ssl_source_dir   => $ssl_source_dir,
        trust_store      => 'mrc.jks',
        trusted_format   => $trusted_format,
        trusted_password => $mrc_jks_password,
      }
    }
    'osd': {
      class {'::fogstore::roles::osd':
        add_repo         => $_repository,
        client_ca        => $client_ca,
        cred_format      => $cred_format,
        cred_password    => $cred_password,
        credential       => $cred_cert,
        dir_ca           => $dir_ca,
        dir_host         => $dir_host,
        dir_port         => $dir_port,
        dir_protocol     => $dir_protocol,
        manage_jks       => $manage_ssl,
        object_dir       => $object_dir,
        properties       => $properties,
        ssl_source_dir   => $ssl_source_dir,
        trust_store      => $trust_store,
        trusted_format   => $trusted_format,
        trusted_password => $osd_jks_password,
      }
    }
    default: { fail "Unknown role ${role}" }
  }
}
