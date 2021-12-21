lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'liquid-arrays/version'

Gem::Specification.new do |spec|
  spec.name          = 'liquid-arrays'
  spec.version       = Arrays::VERSION
  spec.authors       = ['Frostphyr']
  spec.email         = ['contact@frostphyr.com']
  spec.license       = 'Apache-2.0'
  spec.summary       = 'Adds better support for arrays and hashes in Liquid'
  spec.homepage      = 'https://github.com/Frostphyr/liquid-arrays'

  spec.files = Dir['lib/**/*'] + %w(Rakefile Gemfile README.md CHANGELOG.md LICENSE.txt)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'liquid', ['>= 3', '< 5']

  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'rspec', '~> 3.10'
end
