# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Support
        module Mixins
          module Responses
            def close(opts = {})
              params = {
                session_state: lex.session_state,
                request_attributes: lex.request_attributes
              }.merge(opts)
              Response::Close.new(params).to_lex
            end

            def confirm_intent(opts = {})
              params = {
                session_state: lex.session_state,
                request_attributes: lex.request_attributes,
                intent: lex.current_intent
              }.merge(opts)
              lex.session_state.intent = params.fetch(:intent)
              Response::ConfirmIntent.new(params).to_lex
            end

            def delegate(opts = {})
              params = {
                session_state: lex.session_state,
                request_attributes: lex.request_attributes
              }.merge(opts)
              Response::Delegate.new(params).to_lex
            end

            def elicit_intent(opts = {})
              params = {
                session_state: lex.session_state,
                request_attributes: lex.request_attributes
              }.merge(opts)
              Response::ElicitIntent.new(params).to_lex
            end

            def elicit_slot(opts = {})
              params = {
                session_state: lex.session_state,
                request_attributes: lex.request_attributes,
                intent: lex.current_intent
              }.merge(opts)
              lex.session_state.intent = params.fetch(:intent)
              Response::ElicitSlot.new(params).to_lex
            end

            private

            def find_intent_by_name(name:)
              lex.session_state.intent = lex.intents.find(-> { raise ArgumentError, 'intent not found' }) do |intent|
                intent.name == name
              end
            end
          end
        end
      end
    end
  end
end
