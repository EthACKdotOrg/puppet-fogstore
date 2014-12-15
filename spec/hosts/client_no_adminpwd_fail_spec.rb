require 'spec_helper'

os_facts = @os_facts


describe 'client.no-adminpwd.fail' do
  os_facts.each do |osfamily, facts|
    let :facts do
      facts
    end

    describe 'No admin password' do
      it {
        should_not compile.with_all_deps
      }
    end
  end
end
