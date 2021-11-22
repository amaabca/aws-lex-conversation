# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class SlotElicitationStyle
          include Enumeration

          enumeration('Default')
          enumeration('SpellByLetter')
          enumeration('SpellByWord')
        end
      end
    end
  end
end
