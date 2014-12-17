require 'spec_helper'

describe 'role.unknwon.fail' do
  on_supported_os.each do |osfamily, facts|
    let :facts do
      facts
    end

    it 'should fail' do
      should raise_error(Puppet::Error, /unknown node role: fooBar/)
    end
  end
end
