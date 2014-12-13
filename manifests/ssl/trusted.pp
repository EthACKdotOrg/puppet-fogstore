# == Class: fogstore::ssl::trusted
#
# generate trust stores in JKS format.
#
# == Parameters
#
# [*client_ca*]
#       Client CA file name.
#
# [*dir_ca*]
#       Dir CA file name.
#
# [*dir_jks_password*]
#       Dir JKS truststore password.
#
# [*mrc_ca*]
#       MRC CA file name.
#
# [*mrc_jks_password*]
#       MRC JKS truststore password.
#
# [*osd_ca*]
#       OSD CA file name.
#
# [*osd_jks_password*]
#       OSD JKS truststore password.
#
# [*ssl_source_dir*]
#       Source directory for SSL certificates.
#       Might be either on the filesystel (file:///…)
#       or a puppet resource (puppet:///modules/…)
#
class fogstore::ssl::trusted (
  $role,
  $client_ca           = $fogstore::params::client_ca,
  $dir_ca              = $fogstore::params::dir_ca,
  $dir_jks_password    = $fogstore::params::dir_jks_password,
  $mrc_ca              = $fogstore::params::mrc_ca,
  $mrc_jks_password    = $fogstore::params::mrc_jks_password,
  $osd_ca              = $fogstore::params::osd_ca,
  $osd_jks_password    = $fogstore::params::osd_jks_password,
  $ssl_source_dir      = $fogstore::params::ssl_source_dir,
) inherits fogstore::params {

  include ::xtreemfs::internal::workflow
  file {$fogstore::params::trust_location:
    ensure  => directory,
    group   => 'xtreemfs',
    mode    => '0750',
    owner   => 'root',
    require => Anchor[$::xtreemfs::internal::workflow::packages],
  }

  Java_ks {
    require      => File[$fogstore::params::trust_location],
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }

  $ks_base = $fogstore::params::trust_location

  case $role {

    dir: {
      if !$dir_jks_password or $dir_jks_password == '' {
        fail 'Need dir_jks_password for Dir role'
      }
      if !$client_ca or !$mrc_ca or !$osd_ca {
        fail 'Need client, mrc and osd CAs for Dir role'
      }
      java_ks {'dir_client_ca':
        ensure      => latest,
        certificate => "${ssl_source_dir}/${client_ca}",
        target      => "${ks_base}/dir.jks",
        password    => $dir_jks_password,
      }

      java_ks {"dir_mrc_ca:${ks_base}/dir.jks":
        ensure      => latest,
        certificate => "${ssl_source_dir}/${mrc_ca}",
        password    => $dir_jks_password,
      }

      java_ks {"dir_osd_ca:${ks_base}/dir.jks":
        ensure      => latest,
        certificate => "${ssl_source_dir}/${osd_ca}",
        password    => $dir_jks_password,
      }
    }

    introducer: {
      if !$dir_jks_password or $dir_jks_password == '' {
        fail 'Need dir_jks_password for Introducer role'
      }
      if !$mrc_jks_password or $mrc_jks_password == '' {
        fail 'Need mrc_jks_password for Introducer role'
      }
      if !$client_ca or !$mrc_ca or !$osd_ca {
        fail 'Need client, mrc and osd CAs for Introducer role'
      }
      java_ks {'dir_client_ca':
        ensure      => latest,
        certificate => "${ssl_source_dir}/${client_ca}",
        target      => "${ks_base}/dir.jks",
        password    => $dir_jks_password,
      }

      java_ks {"dir_mrc_ca:${ks_base}/dir.jks":
        ensure      => latest,
        certificate => "${ssl_source_dir}/${mrc_ca}",
        password    => $dir_jks_password,
      }

      java_ks {"dir_osd_ca:${ks_base}/dir.jks":
        ensure      => latest,
        certificate => "${ssl_source_dir}/${osd_ca}",
        password    => $dir_jks_password,
      }
      java_ks {'mrc_client_ca':
        ensure      => latest,
        certificate => "${ssl_source_dir}/${client_ca}",
        target      => "${ks_base}/mrc.jks",
        password    => $mrc_jks_password,
      }

      java_ks {"mrc_dir_ca:${ks_base}/mrc.jks":
        ensure      => latest,
        certificate => "${ssl_source_dir}/${dir_ca}",
        password    => $mrc_jks_password,
      }
    }

    mrc: {
      if !$mrc_jks_password or $mrc_jks_password == '' {
        fail 'Need mrc_jks_password for MRC role'
      }
      if !$client_ca or !$dir_ca {
        fail 'Need client and dir CAs for MRC role'
      }
      java_ks {'mrc_client_ca':
        ensure      => latest,
        certificate => "${ssl_source_dir}/${client_ca}",
        target      => "${ks_base}/mrc.jks",
        password    => $mrc_jks_password,
      }

      java_ks {"mrc_dir_ca:${ks_base}/mrc.jks":
        ensure      => latest,
        certificate => "${ssl_source_dir}/${dir_ca}",
        password    => $mrc_jks_password,
      }
    }

    osd: {
      if !$osd_jks_password or $osd_jks_password == '' {
        fail 'Need osd_jks_password for OSD role'
      }
      if !$client_ca or !$dir_ca {
        fail 'Need client and dir CAs for OSD role'
      }
      java_ks {'osd_client_ca':
        ensure      => latest,
        certificate => "${ssl_source_dir}/${client_ca}",
        target      => "${ks_base}/osd.jks",
        password    => $osd_jks_password,
      }

      java_ks {"osd_dir_ca:${ks_base}/osd.jks":
        ensure      => latest,
        certificate => "${ssl_source_dir}/${dir_ca}",
        password    => $osd_jks_password,
      }
    }
    default: { fail "Unknown role ${role}" }
  }
}
