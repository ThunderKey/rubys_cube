# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubys_cube/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubys_cube'
  spec.version       = RubysCube::VERSION
  spec.authors       = ['Nicolas Ganz']
  spec.email         = ['nicolas@keltec.ch']

  spec.summary       = %q{A library to visualize and solve Rubik's Cubes}
  spec.homepage      ='https://github.com/ThunderKey/rubys_cube'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'mittsu', '~> 0.2'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
