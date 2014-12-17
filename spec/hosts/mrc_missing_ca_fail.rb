require 'spec_helper'

describe 'mrc.missing-ca.fail' do
  on_supported_os.each do |osfamily, facts|
    let :facts do
      facts
    end

    it 'should fail' do
      should raise_error(Puppet::Error, /Needs client and dir CAs for mrc/)
    end
  end
end
