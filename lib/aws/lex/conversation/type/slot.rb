# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Slot
          include Base

          optional :shape
          required :name, virtual: true
          optional :lex_value, from: :value, virtual: true
          required :lex_values, from: :values, default: -> { [] }, virtual: true
          optional :active, virtual: true

          coerce(
            shape: SlotShape,
            lex_value: SlotValue,
            lex_values: Array[Slot]
          )

          def to_lex
            super.merge(
              value: transform_to_lex(lex_value),
              values: transform_to_lex(lex_values)
            )
          end

          def value=(val)
            return if shape.list?

            lex_value.interpreted_value = val
          end

          def value
            lex_value.interpreted_value
          end

          def values=(vals)
            return if shape.scalar?

            self.lex_values = vals.map do |val|
              Slot.shrink_wrap(
                shape: 'Scalar',
                value: val
              )
            end
          end

          def values
            lex_values.map(&:interpreted_value)
          end

          def active?
            @active
          end

          def filled?
            shape.list? ? values.present? : value != ''
          end

          def blank?
            !filled?
          end

          def resolve!(index: 0)
            return if shape.list?

            lex_value.resolve!(index: index)
          end

          def resolvable?
            return false if shape.list?

            lex_value.resolvable?
          end

          def requestable?
            active? && blank?
          end
        end
      end
    end
  end
end
