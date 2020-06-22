# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Support
        module Responses
          def close(opts = {})
            params = {
              session_attributes: lex.session_attributes,
              recent_intent_summary_view: lex.recent_intent_summary_view
            }.merge(opts)
            Response::Close.new(params).to_lex
          end

          def confirm_intent(opts = {})
            params = {
              session_attributes: lex.session_attributes,
              recent_intent_summary_view: lex.recent_intent_summary_view,
              intent_name: lex.current_intent.name,
              slots: lex.current_intent.slots
            }.merge(opts)
            Response::ConfirmIntent.new(params).to_lex
          end

          def delegate(opts = {})
            params = {
              session_attributes: lex.session_attributes,
              recent_intent_summary_view: lex.recent_intent_summary_view,
              slots: lex.current_intent.slots
            }.merge(opts)
            Response::Delegate.new(params).to_lex
          end

          def elicit_intent(opts = {})
            params = {
              session_attributes: lex.session_attributes,
              recent_intent_summary_view: lex.recent_intent_summary_view
            }.merge(opts)
            Response::ElicitIntent.new(params).to_lex
          end

          def elicit_slot(opts = {})
            params = {
              session_attributes: lex.session_attributes,
              recent_intent_summary_view: lex.recent_intent_summary_view,
              slots: lex.current_intent.slots,
              intent_name: lex.current_intent.name
            }.merge(opts)
            Response::ElicitSlot.new(params).to_lex
          end
        end
      end
    end
  end
end
