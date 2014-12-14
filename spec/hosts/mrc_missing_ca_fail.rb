require 'spec_helper'

os_facts = @os_facts

describe 'mrc.missing-ca.fail' do
  os_facts.each do |osfamily, facts|
    let :facts do
      facts
    end

    describe 'Missing CA' do
      it {
        expect {
          should compile.with_all_deps
        }.to raise_error()
      }
    end
  end
end
