# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V2
          class InputMode
            include Enumeration

            enumeration('DTMF')
            enumeration('Speech')
            enumeration('Text')
          end
        end
      end
    end
  end
end
