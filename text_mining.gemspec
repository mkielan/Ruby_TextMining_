# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'text_mining/version'

Gem::Specification.new do |spec|
  spec.name = 'text_mining'
  spec.version = TextMining::VERSION
  spec.authors = ['Mariusz Kielan']
  spec.email = ['mariusz@kielan.org']
  spec.description = %q{TODO: Write a gem description}
  spec.summary = %q{TODO: Write a gem summary}
  spec.homepage = ''
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'roo'
  spec.add_development_dependency 'levenshtein-jruby'
  spec.add_development_dependency 'rinruby'
  spec.add_development_dependency 'yalab-ruby-ods'
  spec.add_development_dependency 'nokogiri', '~> 1.6.0'
  spec.add_development_dependency 'mini_portile', '~> 0.5.1'
  spec.add_development_dependency 'rubyzip', '~>1.0.0'
  spec.add_development_dependency 'spreadsheet', '~>0.9.0'
  spec.add_development_dependency 'gruff'
end
