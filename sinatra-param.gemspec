lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sinatra/param/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ['>= 2.5', '< 2.7']

  spec.name          = 'sinatra-param'
  spec.version       = Sinatra::Param::VERSION
  spec.authors       = ['Mattt', 'Jason Garber']
  spec.email         = ['mattt@me.com', 'jason@sixtwothree.org']

  spec.summary       = 'Parameter Validation, Transformation, and Type Coercion for Sinatra applications.'
  spec.description   = 'Declare, validate, and transform URL endpoint parameters.'
  spec.homepage      = 'https://github.com/mattt/sinatra-param'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin|spec)/}) }

  spec.require_paths = ['lib']

  spec.add_development_dependency 'rack-test', '~> 1.1'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'reek', '~> 5.3'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.67.2'
  spec.add_development_dependency 'rubocop-performance', '~> 1.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.31'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
  spec.add_development_dependency 'simplecov-console', '~> 0.4.2'
  spec.add_development_dependency 'sinatra-contrib', '~> 2.0'

  spec.add_runtime_dependency 'activesupport', '~> 5.2'
  spec.add_runtime_dependency 'sinatra', '~> 2.0'
end
