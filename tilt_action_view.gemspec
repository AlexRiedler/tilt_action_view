# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tilt_action_view/version'

Gem::Specification.new do |spec|
  spec.name          = "tilt_action_view"
  spec.version       = TiltActionView::VERSION
  spec.authors       = ["Alex Riedler"]
  spec.email         = ["alex@riedler.ca"]
  spec.description   = %q{An ActionView Template Handler for Tilt}
  spec.summary       = %q{An ActionView Template Handler for Tilt}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"

  spec.add_dependency "actionpack"
  spec.add_dependency "tilt"
  spec.add_dependency "execjs"
end
