require_relative 'lib/sinatra/param/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5', '< 2.8')

  spec.name          = 'sinatra-param'
  spec.version       = Sinatra::Param::VERSION
  spec.authors       = ['Mattt', 'Jason Garber']
  spec.email         = ['mattt@me.com', 'jason@sixtwothree.org']

  spec.summary       = 'Parameter Validation, Transformation, and Type Coercion for Sinatra applications.'
  spec.description   = 'Declare, validate, and transform URL endpoint parameters.'
  spec.homepage      = 'https://github.com/mattt/sinatra-param'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin|spec)/}) }
  end

  spec.require_paths = ['lib']

  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/issues"
  spec.metadata['changelog_uri']   = "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"

  spec.add_runtime_dependency 'activesupport', '~> 6.0'
  spec.add_runtime_dependency 'sinatra', '~> 2.0'
end
