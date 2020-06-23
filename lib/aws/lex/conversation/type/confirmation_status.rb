# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class ConfirmationStatus
          include Enumeration

          enumeration('None')
          enumeration('Confirmed')
          enumeration('Denied')
        end
      end
    end
  end
end
