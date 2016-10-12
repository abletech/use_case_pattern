# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'use_case_pattern/version'

Gem::Specification.new do |spec|
  spec.name          = "use_case_pattern"
  spec.version       = UseCasePattern::VERSION
  spec.authors       = ["Nigel Ramsay"]
  spec.email         = ["nigel@abletech.nz"]

  spec.summary       = "A module that helps you to implement the Use Case design pattern"
  spec.description   = "A module that helps you to implement the Use Case design pattern"
  spec.homepage      = "https://github.com/abletech/use_case_pattern"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.2'

  spec.add_runtime_dependency "activemodel", [">= 4.0.0"]
  spec.add_runtime_dependency "activesupport", [">= 4.0.0"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
