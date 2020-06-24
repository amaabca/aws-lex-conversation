# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Slot
          include Base

          required :name
          required :value

          def to_lex
            value
          end

          def filled?
            value.to_s != ''
          end
        end
      end
    end
  end
end
