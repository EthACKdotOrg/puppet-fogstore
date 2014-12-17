require 'spec_helper'

describe 'introducer.no-dir-cred.fail' do
  on_supported_os.each do |osfamily, facts|
    let :facts do
      facts
    end

    it 'should fail' do
      should raise_error(Puppet::Error, /Need cred_cert, cred_key and cred_password/)
    end
  end
end
