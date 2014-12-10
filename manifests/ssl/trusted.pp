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
  $client_ca           = $fogstore::client_ca,
  $dir_ca              = $fogstore::dir_ca,
  $dir_jks_password    = $fogstore::dir_jks_password,
  $mrc_ca              = $fogstore::mrc_ca,
  $mrc_jks_password    = $fogstore::mrc_jks_password,
  $osd_ca              = $fogstore::osd_ca,
  $osd_jks_password    = $fogstore::osd_jks_password,
  $ssl_source_dir      = $fogstore::ssl_source_dir,
) {
  include ::fogstore::params
  include ::xtreemfs::internal::workflow

  Java_ks {
    require      => File[$fogstore::params::trust_location],
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }

  $ks_base = $fogstore::params::trust_location

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

  java_ks {'osd_client_ca':
    ensure      => latest,
    certificate => "${ssl_source_dir}/${client_ca}",
    target      => "${ks_base}/osd.jks",
    password    => $osd_jks_password,
  }

  java_ks {"osd_dir_ca:${ks_base}/osd.jks":
    ensure      => latest,
    certificate => "${ssl_source_dir}/${osd_ca}",
    password    => $osd_jks_password,
  }
}
