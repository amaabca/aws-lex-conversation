# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class SlotValue
          include Base

          required :original_value
          required :interpreted_value
          required :resolved_values

          alias_method :value, :interpreted_value
          alias_method :value=, :interpreted_value=

          def resolve!(index: 0)
            self.interpreted_value = resolved(index: index)
          end

          def resolved(index: 0)
            resolved_values.fetch(index)
          end

          def resolvable?
            resolved_values.any?
          end
        end
      end
    end
  end
end
