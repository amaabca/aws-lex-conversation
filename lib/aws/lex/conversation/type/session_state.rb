# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class SessionState
          include Base

          optional :active_contexts, default: -> { [] }
          optional :dialog_action
          required :intent, default: -> { {} }
          optional :session_attributes, default: -> { [] }

          coerce(
            active_contexts: Array[Context],
            dialog_action: DialogAction,
            intent: Intent,
            session_attributes: symbolize_hash!
          )
        end
      end
    end
  end
end
