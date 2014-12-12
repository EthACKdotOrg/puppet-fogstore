node default { }

node client {
  $repo = 'http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.10/'
  class {'::fogstore':
    add_repo         => true,
    apt_key_src      => "${repo}/Release.key",
    cred_cert        => 'credential.pem',
    cred_key         => 'credential.key',
    cred_password    => 'credential-password',
    dir_ca           => 'dir-ca.pem',
    mrc_ca           => 'mrc-ca.pem',
    osd_ca           => 'osd-ca.pem',
    pkg_source       => $repo,
    role             => 'client',
    ssl_source_dir   => 'file://.',
  }
}

node dir {
}

node introducer {
}

node mrc {
}

node osd {
  $repo = 'http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.10/'
  class {'::fogstore':
    add_repo         => true,
    apt_key_src      => "${repo}/Release.key",
    client_ca        => 'client-ca.pem',
    cred_cert        => 'credential.pem',
    cred_key         => 'credential.key',
    cred_password    => 'credential-password',
    dir_ca           => 'dir-ca.pem',
    mrc_ca           => 'mrc-ca.pem',
    osd_jks_password => 'osd-jks',
    pkg_source       => $repo,
    role             => 'osd',
    ssl_source_dir   => 'file://.',
  }
}

