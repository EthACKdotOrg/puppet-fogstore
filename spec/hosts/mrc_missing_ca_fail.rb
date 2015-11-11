require 'spec_helper'

describe 'mrc.missing-ca.fail' do
  on_supported_os.each do |osfamily, facts|
    let :facts do
      facts
    end

    it 'should fail' do
      should raise_error(Puppet::Error, /Need dir_ca and dir_ca/)
    end
  end
end
