# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
        class SessionState
          include Base

          optional :active_contexts, default: -> { [] }
          optional :dialog_action
          required :intent, default: -> { {} }
          optional :session_attributes, default: -> { [] }

          coerce(
            active_contexts: Array[Context],
            intent: Intent,
            session_attributes: symbolize_hash!
          )
        end
      end
    end
  end
end
