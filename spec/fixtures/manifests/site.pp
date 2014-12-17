node default { }

$repo = 'http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.10/'
node client {
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

node 'client.no-adminpwd.fail' {
  class {'::fogstore':
    add_repo       => true,
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

node 'dir.no-osd-ca.fail' {
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
    pkg_source       => $repo,
    role             => 'dir',
    ssl_source_dir   => 'file://.',
  }
}

node 'dir.no-adminpwd.fail' {
  class {'::fogstore':
    add_repo         => true,
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
  class {'::fogstore':
    add_repo         => true,
    admin_password   => 'admin-password',
    apt_key_src      => "${repo}/Release.key",
    client_ca        => 'client-ca.pem',
    cred_certs       => {
      'dir'          => 'dir-credential.pem',
      'mrc'          => 'mrc-credential.pem',
    },
    cred_keys        => {
      'dir'          => 'dir-credential.key',
      'mrc'          => 'mrc-credential.key',
    },
    cred_passwords   =>  {
      'dir'          => 'dir-credential-password',
      'mrc'          => 'mrc-credential-password',
    },
    dir_jks_password => 'dir-jks',
    dir_ca           => 'dir-ca.pem',
    mrc_ca           => 'mrc-ca.pem',
    mrc_jks_password => 'mrc-jks',
    osd_ca           => 'osd-ca.pem',
    pkg_source       => $repo,
    role             => 'introducer',
    ssl_source_dir   => 'file://.',
  }
}

node 'introducer.no-dir-cred.fail' {
  class {'::fogstore':
    add_repo         => true,
    admin_password   => 'admin-password',
    apt_key_src      => "${repo}/Release.key",
    client_ca        => 'client-ca.pem',
    cred_certs       => {
      'mrc'          => 'mrc-credential.pem',
    },
    cred_keys        => {
      'dir'          => 'dir-credential.key',
      'mrc'          => 'mrc-credential.key',
    },
    cred_passwords   =>  {
      'dir'          => 'dir-credential-password',
      'mrc'          => 'mrc-credential-password',
    },
    dir_jks_password => 'dir-jks',
    dir_ca           => 'dir-ca.pem',
    mrc_ca           => 'mrc-ca.pem',
    mrc_jks_password => 'mrc-jks',
    osd_ca           => 'osd-ca.pem',
    pkg_source       => $repo,
    role             => 'introducer',
    ssl_source_dir   => 'file://.',
  }
}

node 'introducer.no-adminpwd.fail' {
  class {'::fogstore':
    apt_key_src      => "${repo}/Release.key",
    client_ca        => 'client-ca.pem',
    cred_certs       => {
      'dir'          => 'dir-credential.pem',
      'mrc'          => 'mrc-credential.pem',
    },
    cred_keys        => {
      'dir'          => 'dir-credential.key',
      'mrc'          => 'mrc-credential.key',
    },
    cred_passwords   =>  {
      'dir'          => 'dir-credential-password',
      'mrc'          => 'mrc-credential-password',
    },
    dir_jks_password => 'dir-jks',
    dir_ca           => 'dir-ca.pem',
    mrc_ca           => 'mrc-ca.pem',
    mrc_jks_password => 'mrc-jks',
    osd_ca           => 'osd-ca.pem',
    pkg_source       => $repo,
    role             => 'introducer',
    ssl_source_dir   => 'file://.',
  }
}

node mrc {
  class {'::fogstore':
    add_repo         => true,
    admin_password   => 'admin-password',
    apt_key_src      => "${repo}/Release.key",
    client_ca        => 'client-ca.pem',
    cred_cert        => 'credential.pem',
    cred_key         => 'credential.key',
    cred_password    => 'credential-password',
    dir_ca           => 'dir-ca.pem',
    mrc_jks_password => 'mrc-jks',
    pkg_source       => $repo,
    role             => 'mrc',
    ssl_source_dir   => 'file://.',
  }
}

node 'mrc.missing-ca.fail' {
  class {'::fogstore':
    add_repo         => true,
    admin_password   => 'admin-password',
    apt_key_src      => "${repo}/Release.key",
    cred_cert        => 'credential.pem',
    cred_key         => 'credential.key',
    cred_password    => 'credential-password',
    dir_ca           => 'dir-ca.pem',
    mrc_jks_password => 'mrc-jks',
    pkg_source       => $repo,
    role             => 'mrc',
    ssl_source_dir   => 'file://.',
  }
}

node osd {
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
