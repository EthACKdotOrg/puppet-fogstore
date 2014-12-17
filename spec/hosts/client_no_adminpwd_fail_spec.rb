require 'spec_helper'

describe 'client.no-adminpwd.fail' do
  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    it 'should fail' do
      should raise_error(Puppet::Error, /Need admin_password/)
    end
  end
end
