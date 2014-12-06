#
class fogstore::ssl::trusted (
  $ssl_source_dir,
  $client_ca = ,
) inherits fogstore::params{

  Java_ks {
    require      => File[$::fogstore::params::trust_location],
    trustcacerts => true,
    notify       => Anchor[$::xtreemfs::internal::workflow::configure],
  }

}
