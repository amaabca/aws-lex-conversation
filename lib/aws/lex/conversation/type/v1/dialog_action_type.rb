# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          class DialogActionType
            include Enumeration

            enumeration('ElicitIntent')
            enumeration('ElicitSlot')
            enumeration('ConfirmIntent')
            enumeration('Delegate')
            enumeration('Close')
          end
        end
      end
    end
  end
end
