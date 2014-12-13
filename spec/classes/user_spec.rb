require 'spec_helper'

describe 'fogstore::user' do
  it {
    should contain_user('xtreemfs')
    .with_ensure('present')
    .with_home('/var/lib/xtreemfs')
    .with_managehome('true')
    .with_system('true')
  }
end
