# coding: utf-8

lib = File.expand_path('./lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require './lib/nessus/version.rb'

Gem::Specification.new do |s|
  s.name          = 'moj-nessus-automation'
  s.version       =  Nessus::VERSION
  s.date          = '2014-09-24'
  s.summary       = 'Nessus Automation Gem'
  s.description   = 'A gem to automate nessus vulnerability scanning'
  s.authors       = ['Jeremy Fox']
  s.email         = 'jeremy.fox@digital.justice.gov.uk'
  s.files         = `git ls-files`.split($/)
  s.require_paths = ['lib']
  s.homepage      = 
    'http://rubygems.org/gems/moj-nesssus-automation'
  s.license       = 'MIT'
end