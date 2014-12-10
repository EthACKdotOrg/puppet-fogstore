require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet_facts'
include PuppetFacts

ENV['UNIT_TEST_PLATFORMS'] = 'debian-8-x86_64'

RSpec.configure do |c|
  c.include PuppetlabsSpec::Files

  c.before :each do
    # Ensure that we don't accidentally cache facts and environment
    # between test cases.
    Facter::Util::Loader.any_instance.stubs(:load_all)
    Facter.clear
    Facter.clear_messages

    # Store any environment variables away to be restored later
    @old_env = {}
    ENV.each_key {|k| @old_env[k] = ENV[k]}

    if Gem::Version.new(`puppet --version`) >= Gem::Version.new('3.5')
      Puppet.settings[:strict_variables]=true
    end

    if ENV['FUTURE_PARSER'] == 'yes'
      c.parser='future'
    end
  end

  c.after :each do
    PuppetlabsSpec::Files.cleanup
  end
end

@os_facts = {
  'Debian' => {
    :lsbdistid              => 'Debian',
    :lsbdistcodename        => 'jessie',
    :operatingsystem        => 'Debian',
    :operatingsystemrelease => '8.0',
    :osfamily               => 'Debian',
  }
}

require 'pathname'
dir = Pathname.new(__FILE__).parent
Puppet[:modulepath] = File.join(dir, 'fixtures', 'modules')
