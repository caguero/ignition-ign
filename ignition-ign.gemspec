# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ignition/ign/version'

Gem::Specification.new do |spec|
  spec.name          = "ignition-ign"
  spec.version       = Ignition::Ign::VERSION
  spec.authors       = ["Carlos Agüero"]
  spec.email         = ["caguero@osrfoundation.org"]
  spec.summary       = %q{A command line interface to the ignition tools.}
  spec.description   = %q{This module provides the 'ign' command line tool. This
                       command will allow you to use the functionality provided
                       by the ignition libraries installed in your system. For
                       example, if libignition-transport is installed in your
                       system, you should be able to run `ign topic -l` to
                       print the list of available topics.}
  spec.homepage      = "http://ignitionrobotics.org/"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # Declare that the Gem is compatible with version 1.8 or greater.
  spec.required_ruby_version = ">= 1.8"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
