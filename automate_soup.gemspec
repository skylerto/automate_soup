# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'automate_soup/version'

Gem::Specification.new do |spec|
  spec.name          = 'automate_soup'
  spec.version       = AutomateSoup::VERSION
  spec.authors       = ['Skyler Layne']
  spec.email         = ['skylerclayne@gmail.com']

  spec.summary       = 'Ruby API for interacting with Chef Automate'
  spec.description   = 'Ruby API for interacting with Chef Automate'
  spec.homepage      = 'https://github.com/skylerto/automate_soup'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'byebug'
end
