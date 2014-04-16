require File.expand_path('../lib/briskly/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'briskly'
  gem.authors       = 'Pedro Cunha'
  gem.email         = 'pkunha@gmail.com'
  gem.description   = %q{An in-memory autocomplete}
  gem.summary       = %q{
    An left-hand search in-memory autocomplete wrapper around
    a C extension for fast searches
  }
  gem.homepage      = 'http://github.com/pedrocunha/briskly'
  gem.license       = 'MIT'
  gem.files         = `git ls-files`.split($\)
  gem.require_paths = ['lib']
  gem.version       = Briskly::VERSION

  gem.add_dependency 'i18n'
  gem.add_dependency 'fast_trie'

  gem.add_development_dependency 'bundler', '~> 1.4'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'pry', '~> 0'
  gem.add_development_dependency 'pry-nav', '~> 0'
  gem.add_development_dependency 'guard', '~> 0'
  gem.add_development_dependency 'guard-rspec', '~> 0'
end
