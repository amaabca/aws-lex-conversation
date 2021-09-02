# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Spec
        module Matchers
          extend RSpec::Matchers::DSL

          # :nocov:
          def build_event(input)
            case input
            when Aws::Lex::Conversation
              input.lex.to_lex
            when Hash
              input
            else
              raise ArgumentError, \
                    'expected instance of Aws::Lex::Conversation ' \
                    "or Hash, got: #{input.inspect}"
            end
          end
          # :nocov:

          matcher(:have_transcript) do |expected|
            match do |actual|
              build_event(actual).fetch(:inputTranscript) == expected
            end

            # :nocov:
            failure_message do |actual|
              response = build_event(actual)
              "expected a transcript of '#{expected}', got '#{response.fetch(:inputTranscript)}'"
            end

            failure_message_when_negated do |actual|
              response = build_event(actual)
              "expected transcript to not equal '#{expected}', got '#{response.fetch(:inputTranscript)}'"
            end
            # :nocov:
          end

          matcher(:route_to_intent) do |expected|
            match do |actual|
              build_event(actual).dig(:sessionState, :intent, :name) == expected
            end

            # :nocov:
            failure_message do |actual|
              response = build_event(actual)
              "expected intent to be '#{expected}', got '#{response.dig(:sessionState, :intent, :name)}'"
            end

            failure_message_when_negated do |actual|
              response = build_event(actual)
              "expected intent to not be '#{expected}', got '#{response.dig(:sessionState, :intent, :name)}'"
            end
            # :nocov:
          end

          matcher(:have_active_context) do |expected|
            match do |actual|
              build_event(actual).dig(:sessionState, :activeContexts).any? { |c| c[:name] == expected }
            end

            # :nocov:
            failure_message do |actual|
              response = build_event(actual)
              names = response.dig(:sessionState, :activeContexts).map { |c| c[:name] }.inspect
              "expected active context of `#{expected}` in #{names}"
            end

            failure_message_when_negated do |actual|
              response = build_event(actual)
              names = response.dig(:sessionState, :activeContexts).map { |c| c[:name] }.inspect
              "expected active contexts to not include `#{expected}`, got:  #{names}"
            end
            # :nocov:
          end

          matcher(:have_invocation_source) do |expected|
            match do |actual|
              build_event(actual).fetch(:invocationSource) == expected
            end

            # :nocov:
            failure_message do |actual|
              response = build_event(actual)
              "expected invocationSource of `#{expected}`, got: #{response[:invocationSource]}"
            end

            failure_message_when_negated do |actual|
              response = build_event(actual)
              "expected invocationSource to not be `#{expected}`, got:  #{response[:invocationSource]}"
            end
            # :nocov:
          end

          matcher(:have_input_mode) do |expected|
            match do |actual|
              build_event(actual).fetch(:inputMode) == expected
            end

            # :nocov:
            failure_message do |actual|
              response = build_event(actual)
              "expected inputMode of `#{expected}`, got: #{response[:inputMode]}"
            end

            failure_message_when_negated do |actual|
              response = build_event(actual)
              "expected inputMode to not be `#{expected}`, got:  #{response[:inputMode]}"
            end
            # :nocov:
          end

          matcher(:have_interpretation) do |expected|
            match do |actual|
              build_event(actual).fetch(:interpretations).any? { |i| i.dig(:intent, :name) == expected }
            end

            # :nocov:
            failure_message do |actual|
              response = build_event(actual)
              names = response[:interpretations].map { |i| i.dig(:intent, :name) }.inspect
              "expected interpretation of `#{expected}` in #{names}"
            end

            failure_message_when_negated do |actual|
              response = build_event(actual)
              names = response[:interpretations].map { |_i| c.dig(:intent, :name) }.inspect
              "expected interpretations to not include `#{expected}`, got:  #{names}"
            end
            # :nocov:
          end

          matcher(:have_slot) do |opts|
            name = opts.fetch(:name)
            expected_slot = {
              shape: opts.fetch(:shape) { 'Scalar' },
              value: {
                originalValue: opts.fetch(:original_value) { opts[:value] },
                interpretedValue: opts.fetch(:interpreted_value) { opts[:value] },
                resolvedValues: opts.fetch(:resolved_values) { [opts[:value]] }
              }
            }

            match do |actual|
              slot = build_event(actual).dig(:sessionState, :intent, :slots, name.to_sym)
              slot.slice(*expected_slot.keys) == expected_slot
            end

            # :nocov:
            failure_message do |actual|
              slot = build_event(actual).dig(:sessionState, :intent, :slots, name.to_sym)
              "expected #{expected_slot.inspect} to equal #{slot.inspect}"
            end

            failure_message_when_negated do |actual|
              slot = build_event(actual).dig(:sessionState, :intent, :slots, name.to_sym)
              "expected #{expected_slot.inspect} to not equal #{slot.inspect}"
            end
            # :nocov:
          end

          matcher(:have_action) do |expected|
            match do |actual|
              build_event(actual).dig(:sessionState, :dialogAction, :type) == expected
            end

            # :nocov:
            failure_message do |actual|
              "expected #{build_event(actual).dig(:sessionState, :dialogAction, :type)} to equal #{expected}"
            end

            failure_message_when_negated do |actual|
              "expected #{build_event(actual).dig(:sessionState, :dialogAction, :type)} to not equal #{expected}"
            end
            # :nocov:
          end

          matcher(:elicit_slot) do |expected|
            match do |actual|
              response = build_event(actual)

              response.dig(:sessionState, :dialogAction, :type) == 'ElicitSlot' &&
                response.dig(:sessionState, :dialogAction, :slotToElicit) == expected
            end
          end

          matcher(:include_session_values) do |expected|
            match do |actual|
              response = build_event(actual)
              response.dig(:sessionState, :sessionAttributes).slice(*expected.keys) == expected
            end
          end

          matcher(:have_message) do |expected|
            match do |actual|
              build_event(actual)[:messages].any? { |m| m.slice(*expected.keys) == expected }
            end

            # :nocov:
            failure_message do |actual|
              "expected matching message of #{expected.inspect} in #{build_event(actual)[:messages].inspect}"
            end

            failure_message_when_negated do |actual|
              "found matching message of #{expected.inspect} in #{build_event(actual)[:messages].inspect}"
            end
            # :nocov:
          end
        end
      end
    end
  end
end
