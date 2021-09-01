module Aws
  module Lex
    class Conversation
      module Spec
        module Matchers
          extend RSpec::Matchers::DSL

          def build_response(input)
            case input
            when Aws::Lex::Conversation
              input.respond
            when Hash
              input
            else
              raise ArgumentError, \
              'expected instance of Aws::Lex::Conversation ' \
              "or Hash, got: #{input.inspect}"
            end
          end

          matcher(:have_transcript) do |expected|
            match do |actual|
              build_response(actual).fetch(:inputTranscript) == expected
            end

            # :nocov:
            failure_message do |actual|
              response = build_response(actual)
              "expected a transcript of '#{expected}', got '#{response.fetch(:inputTranscript)}'"
            end

            failure_message_when_negated do |actual|
              response = build_response(actual)
              "expected transcript to not equal '#{expected}', got '#{response.fetch(:inputTranscript)}'"
            end
            # :nocov:
          end

          matcher(:route_to_intent) do |expected|
            match do |actual|
              build_response(actual).dig(:sessionState, :intent, :name) == expected
            end

            # :nocov:
            failure_message do |actual|
              response = build_response(actual)
              "expected intent to be '#{expected}', got '#{response.dig(:sessionState, :intent, :name)}'"
            end

            failure_message_when_negated do |actual|
              response = build_response(actual)
              "expected intent to not be '#{expected}', got '#{response.dig(:sessionState, :intent, :name)}'"
            end
            # :nocov:
          end

          matcher(:have_active_context) do |expected|
            match do |actual|
              build_response(actual).dig(:sessionState, :activeContexts).any? { |c| c[:name] == expected }
            end

            # :nocov:
            failure_message do |actual|
              response = build_response(actual)
              names = response.dig(:sessionState, :activeContexts).map { |c| c[:name] }.inspect
              "expected active context of `#{expected}` in #{names}"
            end

            failure_message_when_negated do |actual|
              response = build_response(actual)
              names = response.dig(:sessionState, :activeContexts).map { |c| c[:name] }.inspect
              "expected active contexts to not include `#{expected}`, got:  #{names}"
            end
            # :nocov:
          end

          matcher(:have_invocation_source) do |expected|
            match do |actual|
              build_response(actual).fetch(:invocationSource) == expected
            end

            # :nocov:
            failure_message do |actual|
              response = build_response(actual)
              "expected invocationSource of `#{expected}`, got: #{response[:invocationSource]}"
            end

            failure_message_when_negated do |actual|
              response = build_response(actual)
              "expected invocationSource to not be `#{expected}`, got:  #{response[:invocationSource]}"
            end
            # :nocov:
          end

          matcher(:have_interpretation) do |expected|
            match do |actual|
              build_response(actual).fetch(:interpretations).any? { |i| i.dig(:intent, :name) == expected }
            end

            # :nocov:
            failure_message do |actual|
              response = build_response(actual)
              names = response[:interpretations].map { |i| i.dig(:intent, :name) }.inspect
              "expected interpretation of `#{expected}` in #{names}"
            end

            failure_message_when_negated do |actual|
              response = build_response(actual)
              names = response[:interpretations].map { |i| c.dig(:intent, :name) }.inspect
              "expected interpretations to not include `#{expected}`, got:  #{names}"
            end
            # :nocov:
          end
        end
      end
    end
  end
end
