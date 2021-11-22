# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class DialogAction
          include Base

          optional :slot_to_elicit
          optional :slot_elicitation_style, default: -> { 'Default' }
          required :type

          coerce(
            type: DialogActionType,
            slot_elicitation_style: SlotElicitationStyle
          )
        end
      end
    end
  end
end
