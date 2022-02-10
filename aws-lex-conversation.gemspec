# frozen_string_literal: true

require_relative 'lib/aws/lex/conversation/version'

Gem::Specification.new do |spec|
  spec.name = 'aws-lex-conversation'
  spec.version = Aws::Lex::Conversation::VERSION
  spec.authors = [
    'Jesse Doyle',
    'Michael van den Beuken',
    'Darko Dosenovic',
    'Zoie Carnegie',
    'Carlos Mejia Castelo'
  ]
  spec.email = [
    'jesse.doyle@ama.ab.ca',
    'michael.vandenbeuken@ama.ab.ca',
    'darko.dosenovic@ama.ab.ca',
    'zoie.carnegie@ama.ab.ca',
    'carlos.mejiacastelo@ama.ab.ca'
  ]

  spec.summary = 'AWS Lex Conversation Dialog Management'
  spec.description = 'Easily manage the flow and logic of your AWS Lex conversations.'
  spec.homepage = 'https://github.com/amaabca/aws-lex-conversation'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|data)/}) }
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'shrink_wrap'
end
