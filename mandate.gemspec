lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mandate/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.6.0'
  spec.name          = "mandate"
  spec.version       = Mandate::VERSION
  spec.authors       = ["Jeremy Walker"]
  spec.email         = ["jez.walker@gmail.com"]
  spec.licenses = ['MIT']

  spec.summary       = 'A simple command-pattern helper gem for Ruby'
  spec.description   = 'This Ruby Gem adds functionality for the command pattern in Ruby, and for memoization.'
  spec.homepage      = "https://github.com/iHiD/mandate"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 12.3"
end
