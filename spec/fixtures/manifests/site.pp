node default { }

node client {
  $repo = 'http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.10/'
  class {'::fogstore':
    add_repo       => true,
    admin_password => 'fooBar',
    apt_key_src    => "${repo}/Release.key",
    cred_cert      => 'credential.pem',
    cred_key       => 'credential.key',
    cred_password  => 'credential-password',
    dir_ca         => 'dir-ca.pem',
    mrc_ca         => 'mrc-ca.pem',
    osd_ca         => 'osd-ca.pem',
    pkg_source     => $repo,
    role           => 'client',
    ssl_source_dir => 'file://.',
    volumes        => {
      'test1'      => {
        ensure     => present,
      },
      'test2'      => {
        ensure     => 'absent',
      }
    },
  }
}

node dir {
  $repo = 'http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.10/'
  class {'::fogstore':
    add_repo         => true,
    admin_password   => 'admin-password',
    apt_key_src      => "${repo}/Release.key",
    client_ca        => 'client-ca.pem',
    cred_cert        => 'credential.pem',
    cred_key         => 'credential.key',
    cred_password    => 'credential-password',
    dir_jks_password => 'dir-jks',
    mrc_ca           => 'mrc-ca.pem',
    osd_ca           => 'osd-ca.pem',
    pkg_source       => $repo,
    role             => 'dir',
    ssl_source_dir   => 'file://.',
  }
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

node 'osd.nocred.fail' {
  $repo = 'http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.10/'
  class {'::fogstore':
    add_repo         => true,
    apt_key_src      => "${repo}/Release.key",
    client_ca        => 'client-ca.pem',
    cred_cert        => 'credential.pem',
    cred_key         => 'credential.key',
    dir_ca           => 'dir-ca.pem',
    mrc_ca           => 'mrc-ca.pem',
    osd_jks_password => 'osd-jks',
    pkg_source       => $repo,
    role             => 'osd',
    ssl_source_dir   => 'file://.',
  }
}

node 'role.unknwon.fail' {
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
    role             => 'fooBar',
    ssl_source_dir   => 'file://.',
  }
}
