# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class DialogActionType
          include Enumeration

          enumeration('Close')
          enumeration('ConfirmIntent')
          enumeration('Delegate')
          enumeration('ElicitIntent')
          enumeration('ElicitSlot')
        end
      end
    end
  end
end
