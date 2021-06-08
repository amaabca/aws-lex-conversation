# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          class Response
            include Base

            required :dialog_action
            optional :session_attributes
            optional :recent_intent_summary_view
            optional :active_contexts
          end
        end
      end
    end
  end
end
