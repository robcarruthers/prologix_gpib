# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prologix_gpib/version'

Gem::Specification.new do |spec|
  spec.name = 'prologix_gpib'
  spec.version = PrologixGpib::VERSION
  spec.authors = ['Rob Carruthers']
  spec.email = ['robcarruthers@mac.com']

  spec.summary = 'Prologix GPIB controller ruby wrapper.'
  spec.description = 'Ruby wrapper for the Prologix GPIB controllers, USB & Ethernet.'
  spec.homepage = 'https://github.com/robcarruthers/prologix_gpib'
  spec.license = 'MIT'

  # spec.metadata['allowed_push_host'] = "http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/robcarruthers/prologix_gpib'
  spec.metadata['changelog_uri'] = 'https://github.com/robcarruthers/prologix_gpib'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) { `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) } }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 7.0.1'
  spec.add_dependency 'bindata', '~> 2.4.10'
  spec.add_dependency 'rubyserial', '~> 0.6.0'
  spec.add_dependency 'terminal-table', '~> 3.0.2'
  spec.add_dependency 'thor', '~> 1.2.1'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
