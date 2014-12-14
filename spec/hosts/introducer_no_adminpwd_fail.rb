require 'spec_helper'

os_facts = @os_facts

describe 'introducer.no-adminpwd.fail' do
  os_facts.each do |osfamily, facts|
    let :facts do
      facts
    end

    describe 'Missing admin password' do
      it {
        expect {
          should compile.with_all_deps
        }.to raise_error()
      }
    end
  end
end
