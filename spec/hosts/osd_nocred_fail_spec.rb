require 'spec_helper'

describe 'osd.nocred.fail' do
  on_supported_os.each do |osfamily, facts|
    let :facts do
      facts
    end

    it 'should fail' do
      should raise_error(Puppet::Error, /Need either cred_password or cred_passwords!/)
    end
  end
end
