require 'spec_helper'

os_facts = @os_facts

describe 'introducer.no-adminpwd.fail' do
  os_facts.each do |osfamily, facts|
    let :facts do
      facts
    end

    describe 'Missing admin password' do
      it {
        should_not compile.with_all_deps
      }
    end
  end
end
