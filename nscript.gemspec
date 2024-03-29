# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nscript/version'

Gem::Specification.new do |spec|
  spec.name          = "nscript"
  spec.version       = NScript::VERSION
  spec.authors       = ["Arkadiusz Buras"]
  spec.email         = ["macbury@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rb-readline"
  spec.add_development_dependency "guard-yard"
  spec.add_development_dependency "redcarpet"
  spec.add_development_dependency "logger"
  spec.add_dependency "docile"
  spec.add_dependency "eventmachine"
  spec.add_dependency "em-http-request"
  spec.add_dependency "json"
  spec.add_dependency "mash"
  spec.add_dependency "inferno"
end
