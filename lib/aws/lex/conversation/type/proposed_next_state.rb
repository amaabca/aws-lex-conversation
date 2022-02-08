# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class ProposedNextState
          include Base

          required :dialog_action
          required :intent

          coerce(
            dialog_action: DialogAction,
            intent: Intent
          )
        end
      end
    end
  end
end
