require 'spec_helper'

os_facts = @os_facts

describe 'introducer.no-dir-cred.fail' do
  os_facts.each do |osfamily, facts|
    let :facts do
      facts
    end

    describe 'No dir credential' do
      it {
        should_not compile.with_all_deps
      }
    end
  end
end
