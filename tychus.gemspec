# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tychus/version'

Gem::Specification.new do |spec|
  spec.name          = "tychus"
  spec.version       = Tychus::VERSION
  spec.authors       = ["Wayne Yang"]
  spec.email         = ["waysidekoi@gmail.com"]
  spec.summary       = %q{Web recipe parser}
  spec.homepage      = "https://github.com/waysidekoi/tychus"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_dependency "nokogiri", "~> 1.6.3"
  spec.add_dependency "addressable", "~> 2.3.6"
  spec.add_dependency "activesupport"
end
