# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'social_count/version'

Gem::Specification.new do |spec|
  spec.name          = "social_count"
  spec.version       = SocialCount::VERSION
  spec.authors       = ["Isaac Betesh"]
  spec.email         = ["iybetesh@gmail.com"]
  spec.description   = %q{Want to know how popular you are?  This gem helps you look up how many Facebook friends and Twitter followers you have.}
  spec.summary       = `cat README.md`
  spec.homepage      = "https://github.com/betesh/social_count"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "fb_graph"
  spec.add_dependency "twitter_oauth", '~> 0.4.94'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
