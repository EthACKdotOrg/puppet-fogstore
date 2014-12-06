#
class fogstore::ssl::trusted (
  $client_ca,
  $client_jks_password,
  $dir_ca,
  $dir_jks_password,
  $mrc_ca,
  $mrc_jks_password,
  $osd_ca,
  $osd_jks_password,
  $ssl_source_dir,
) inherits fogstore::params {

  Java_ks {
    require      => File[$::fogstore::params::trust_location],
    trustcacerts => true,
    notify       => Anchor[$::xtreemfs::internal::workflow::configure],
  }

  java_ks {'dir_client_ca':
    ensure       => latest,
    certificate  => "${ssl_source_dir}/${client_ca}",
    target       => "${ks_base}/dir.jks",
    password     => $dir_jks_password,
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }
  
  java_ks {"dir_mrc_ca:${ks_base}/dir.jks":
    ensure       => latest,
    certificate  => "${ssl_source_dir}/${mrc_ca}",
    password     => $dir_jks_password,
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }

  java_ks {"dir_osd_ca:${ks_base}/dir.jks":
    ensure       => latest,
    certificate  => "${ssl_source_dir}/${osd_ca}",
    password     => $dir_jks_password,
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }

  java_ks {'mrc_client_ca':
    ensure       => latest,
    certificate  => "${ssl_source_dir}/${client_ca}",
    target       => "${ks_base}/mrc.jks",
    password     => $mrc_jks_password,
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }
  
  java_ks {"mrc_dir_ca:${ks_base}/mrc.jks":
    ensure       => latest,
    certificate  => "${ssl_base}/${dir_ca}",
    password     => $mrc_jks_password,
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }

  java_ks {'osd_client_ca':
    ensure       => latest,
    certificate  => "${ssl_source_dir}/${client_ca}",
    target       => "${ks_base}/osd.jks",
    password     => $osd_jks_password,
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }
  
  java_ks {"osd_dir_ca:${ks_base}/osd.jks":
    ensure       => latest,
    certificate  => "${ssl_source_dir}/${osd_ca}",
    password     => $osd_jks_password,
    trustcacerts => true,
    notify       => Anchor[$xtreemfs::internal::workflow::configure],
  }
}
