# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class DialogAction
          include Base

          required :slot_to_elicit
          required :type

          coerce(
            type: DialogActionType
          )
        end
      end
    end
  end
end
