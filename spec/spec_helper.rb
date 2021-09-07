# frozen_string_literal: true

require 'simplecov'
require 'ostruct'
require 'securerandom'
require 'bundler/setup'
require 'pry'
require 'aws-lex-conversation'
require 'aws/lex/conversation/spec'
require 'factory_bot'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.include(FactoryBot::Syntax::Methods)
  config.include(Helpers::Fixtures)
  config.include(Aws::Lex::Conversation::Spec)
  config.example_status_persistence_file_path = '.rspec_status'

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
