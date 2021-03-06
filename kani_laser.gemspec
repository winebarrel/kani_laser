# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kani_laser/version'

Gem::Specification.new do |spec|
  spec.name          = 'kani_laser'
  spec.version       = KaniLaser::VERSION
  spec.authors       = ['winebarrel']
  spec.email         = ['sugawara@winebarrel.jp']

  spec.summary       = 'SendGrid v3 Mail Send API Ruby Client that validates API request body using JSON Schema.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/winebarrel/kani_laser'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/winebarrel/kani_laser'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_dependency 'faraday', '~> 0.17.1'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'json-schema'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'nokogiri'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
