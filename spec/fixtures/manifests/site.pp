node default { }

node simple_osd {
  class {'fogstore':
    role             => 'osd',
    cred_password    => 'fooBar',
    ssl_source_dir   => '.',
    trusted_password => 'barFoo',
  }
}

node simple_client {
}

node simple_dir {
}

node simple_mrc {
}

node simple_introducer {
}
