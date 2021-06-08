# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Support
        module Mixins
          module V1
            module Responses
              def close(opts = {})
                params = {
                  active_contexts: lex.active_contexts,
                  recent_intent_summary_view: pending_checkpoints,
                  session_attributes: lex.session_attributes
                }.merge(opts)
                Response::V1::Close.new(params).to_lex
              end

              def confirm_intent(opts = {})
                params = {
                  active_contexts: lex.active_contexts,
                  intent_name: lex.current_intent.name,
                  recent_intent_summary_view: pending_checkpoints,
                  session_attributes: lex.session_attributes,
                  slots: lex.current_intent.slots
                }.merge(opts)
                Response::V1::ConfirmIntent.new(params).to_lex
              end

              def delegate(opts = {})
                params = {
                  active_contexts: lex.active_contexts,
                  recent_intent_summary_view: pending_checkpoints,
                  session_attributes: lex.session_attributes,
                  slots: lex.current_intent.slots
                }.merge(opts)
                Response::V1::Delegate.new(params).to_lex
              end

              def elicit_intent(opts = {})
                params = {
                  active_contexts: lex.active_contexts,
                  recent_intent_summary_view: pending_checkpoints,
                  session_attributes: lex.session_attributes
                }.merge(opts)
                Response::V1::ElicitIntent.new(params).to_lex
              end

              def elicit_slot(opts = {})
                params = {
                  active_contexts: lex.active_contexts,
                  intent_name: lex.current_intent.name,
                  recent_intent_summary_view: pending_checkpoints,
                  session_attributes: lex.session_attributes,
                  slots: lex.current_intent.slots
                }.merge(opts)
                Response::V1::ElicitSlot.new(params).to_lex
              end
            end
          end
        end
      end
    end
  end
end
