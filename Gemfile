source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :test do
  gem "rake",                   :require => false
  gem "rspec-puppet",           :require => false, :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem 'rspec-puppet-facts',     :require => false, :git => 'https://github.com/EthACKdotOrg/rspec-puppet-facts.git'
  gem "puppetlabs_spec_helper", :require => false
  gem "metadata-json-lint",     :require => false
  gem 'puppet-lint',            :require => false
  gem 'puppet_facts',           :require => false, :git => 'https://github.com/camptocamp/puppet_facts.git'
  gem 'coveralls',              :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
    gem 'facter', facterversion, :require => false
else
    gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
    gem 'puppet', puppetversion, :require => false
else
    gem 'puppet', :require => false
end

# vim:ft=ruby
