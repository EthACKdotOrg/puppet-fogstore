# create user, event if managed by package
# this will ensure integrity.
class fogstore::user {
  user {'xtreemfs':
    ensure     => present,
    home       => '/var/lib/xtreemfs',
    managehome => true,
    system     => true,
  }
}
