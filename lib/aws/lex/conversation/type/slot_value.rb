# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class SlotValue
          include Base

          optional :original_value
          optional :interpreted_value
          required :resolved_values, default: -> { [] }

          alias_method :value, :interpreted_value
          alias_method :value=, :interpreted_value=

          def to_lex
            {
              interpretedValue: interpreted_value,
              originalValue: original_value,
              resolvedValues: resolved_values
            }
          end

          def resolve!(index: 0)
            self.interpreted_value = resolved(index: index)
          end

          def resolved(index: 0)
            resolved_values.fetch(index) { interpreted_value }
          end

          def resolvable?
            resolved_values.any?
          end
        end
      end
    end
  end
end
