# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class SlotShape
          include Enumeration

          enumeration('List')
          enumeration('Scalar')
        end
      end
    end
  end
end
