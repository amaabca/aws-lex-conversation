# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Response
          include Base

          required :dialog_action
          optional :session_attributes
          optional :recent_intent_summary_view
        end
      end
    end
  end
end
