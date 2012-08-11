# -*- encoding: utf-8 -*-
require File.expand_path('../lib/git_reporter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Satoshi Namai"]
  gem.email         = ["ainame954@facebook.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "git_reporter"
  gem.require_paths = ["lib"]
  gem.version       = GitReporter::VERSION
end
