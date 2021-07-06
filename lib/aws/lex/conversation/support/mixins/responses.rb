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
                request_attributes: lex.request_attributes
              }.merge(opts)
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
                request_attributes: lex.request_attributes
              }.merge(opts)
              Response::ElicitSlot.new(params).to_lex
            end
          end
        end
      end
    end
  end
end
