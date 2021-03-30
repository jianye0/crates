# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'crates'
  s.version     = '0.1.0'
  s.summary     = 'Print and Save Cryptocurrency Rates'
  s.description = <<~DESC
    Collect cryptocurrency prices for desired fiat currency.
    Print colorized output (or not), save as CSV (or not).
    Lightweight, fast, simple and easily extendible. 
  DESC
  s.authors = ['decentralizuj']
  s.files   = ['lib/crates.rb']
  s.homepage = 'https://github.com/decentralizuj/crates'
  s.license = 'MIT'

  s.metadata['homepage_uri'] = 'https://github.com/decentralizuj/crates'
  s.metadata['source_code_uri'] = 'https://github.com/decentralizuj/crates'
  s.metadata['bug_tracker_uri'] = 'https://github.com/decentralizuj/crates/issues'

  s.files = ['bin/crates', 'lib/crates.rb', 'LICENSE', 'README.md', 'crates.gemspec']
  s.bindir = 'bin'
  s.executables = ['crates']
  s.require_paths = ['lib']

  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'colorize'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
end


