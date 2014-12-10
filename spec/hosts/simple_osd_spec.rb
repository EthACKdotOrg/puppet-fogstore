require 'spec_helper'

os_facts = @os_facts


os_facts.each do |osfamily, facts|
  describe 'simple OSD node' do
    let :facts do
      facts
    end
    
    describe 'should compile' do
      it { should compile }
    end

  end
end
