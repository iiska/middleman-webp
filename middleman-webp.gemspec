lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "middleman-webp/version"

Gem::Specification.new do |spec|
  spec.name = "middleman-webp"
  spec.version = Middleman::Webp::VERSION
  spec.authors = ["Juhamatti Niemelä"]
  spec.email = ["iiska@iki.fi"]
  spec.summary = "WebP image conversion for Middleman"
  spec.description = "Generate WebP versions of each image used in Middleman site during build."
  spec.homepage = "https://github.com/iiska/middleman-webp"
  spec.license = "MIT"

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_dependency "middleman-core", "~> 4.0"
  spec.add_dependency "shell", "~> 0.8.1"

  spec.add_development_dependency "bundler", ">= 1.5"
  spec.add_development_dependency "middleman-cli", "~> 4.0.0"
  spec.add_development_dependency "rake"
  # spec.add_development_dependency "simplecov"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "rubocop", "~> 1.49.0"
  spec.add_development_dependency "standard", "~> 1.26.0"
  spec.add_development_dependency "rubocop-rake", "~> 0.6.0"
end
