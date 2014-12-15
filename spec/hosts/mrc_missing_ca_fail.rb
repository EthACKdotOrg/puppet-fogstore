require 'spec_helper'

os_facts = @os_facts

describe 'mrc.missing-ca.fail' do
  os_facts.each do |osfamily, facts|
    let :facts do
      facts
    end

    describe 'Missing CA' do
      it {
        should_not compile.with_all_deps
      }
    end
  end
end
