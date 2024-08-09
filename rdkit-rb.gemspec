require_relative "lib/rdkit/version"

Gem::Specification.new do |spec|
  spec.name          = "rdkit-rb"
  spec.version       = RDKit::VERSION
  spec.summary       = "Cheminformatics for Ruby, powered by RDKit"
  spec.homepage      = "https://github.com/ankane/rdkit-ruby"
  spec.license       = "BSD-3-Clause"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib,vendor}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 3.1"
end
