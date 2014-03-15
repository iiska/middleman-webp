# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman-webp/version'

Gem::Specification.new do |spec|
  spec.name          = "middleman-webp"
  spec.version       = Middleman::Webp::VERSION
  spec.authors       = ["Juhamatti Niemelä"]
  spec.email         = ["iiska@iki.fi"]
  spec.summary       = %q{Generate WebP versions of each image in site}
  spec.description   = %q{Generate WebP versions of each image used in Middleman site during build.}
  spec.homepage      = "http://github.com/iiska/middleman-webp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "middleman-core", "~> 3.0.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "simplecov"
end
