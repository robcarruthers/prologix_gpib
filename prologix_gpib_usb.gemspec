# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prologix_gpib_usb/version'

Gem::Specification.new do |spec|
  spec.name          = 'prologix_gpib_usb'
  spec.version       = PrologixGpibUsb::VERSION
  spec.authors       = ['Rob Carruthers']
  spec.email         = ['robcarruthers@mac.com']

  spec.summary       = 'Prologix GPIB USB controiller driver for ruby.'
  spec.description   = 'Prologix GPIB USB controiller driver for ruby.'
  spec.homepage      = 'https://codemuster.co.nz'

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://codemuster.co.nz'
  spec.metadata['changelog_uri'] = 'https://codemuster.co.nz'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'rubyserial'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
