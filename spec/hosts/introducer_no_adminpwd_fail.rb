require 'spec_helper'

describe 'introducer.no-adminpwd.fail' do
  on_supported_os.each do |osfamily, facts|
    let :facts do
      facts
    end

    it 'should fail' do
      should raise_error(Puppet::Error, /Need admin_password/)
    end
  end
end
