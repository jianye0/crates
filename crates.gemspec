# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'crates'
  s.version     = '0.1.0'
  s.summary     = 'Print and Save Cryptocurrency Rates'
  s.description = <<~DESC
    Collect cryptocurrency prices for any fiat currency.
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

  s.add_runtime_dependency 'rest-client', '~> 2.1.0'
  s.add_runtime_dependency 'colorize', '~> 0.8.1'

  s.add_development_dependency 'bundler', '~> 2.2.9'
  s.add_development_dependency 'rake', '~> 13.0.3'
end


