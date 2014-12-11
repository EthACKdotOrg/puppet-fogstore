require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.send('disable_80chars')

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  ".vendor/**/*",
  "spec/**/*",
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

desc "Lint metadata.json file"
task :metadata do
  sh "metadata-json-lint metadata.json"
end
