require 'spec_helper'

describe 'fogstore::user' do
  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end
    context "on #{os}" do
      it {
        should contain_user('xtreemfs')
        .with_ensure('present')
        .with_home('/var/lib/xtreemfs')
        .with_managehome('true')
        .with_system('true')
      }
    end
  end
end
