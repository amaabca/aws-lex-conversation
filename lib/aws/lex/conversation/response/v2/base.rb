# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Response
        class Base
          attr_accessor(
            :messages,
            :session_state,
            :request_attributes
          )

          def initialize(opts = {})
            self.messages = opts[:messages]
            self.session_state = opts[:session_state]
            self.request_attributes = opts[:request_attributes]
          end

          def dialog_action
            raise NotImplementedError, 'define dialog_action in a subclass'
          end

          required :session_state
            optional :messages
            optional :request_attributes

          def to_lex
            Type::Response.new(
              active_contexts: active_contexts,
              dialog_action: dialog_action,
              recent_intent_summary_view: recent_intent_summary_view,
              session_attributes: session_attributes
            ).to_lex
          end
        end
      end
    end
  end
end
