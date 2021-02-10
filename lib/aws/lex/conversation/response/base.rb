# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Response
        class Base
          attr_accessor(
            :active_contexts,
            :recent_intent_summary_view,
            :session_attributes
          )

          def initialize(opts = {})
            self.active_contexts = opts[:active_contexts]
            self.recent_intent_summary_view = opts[:recent_intent_summary_view]
            self.session_attributes = opts[:session_attributes]
          end

          def dialog_action
            raise NotImplementedError, 'define dialog_action in a subclass'
          end

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
