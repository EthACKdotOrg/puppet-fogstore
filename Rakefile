require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  ".vendor/**/*",
  "spec/**/*",
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.send('disable_80chars')

task :metadata do
  sh "metadata-json-lint metadata.json"
end

desc "Run syntax, lint, and spec tests."
task :test => [
  :metadata,
  :syntax,
  :lint,
  :spec_prep,
  :spec_standalone,
]
