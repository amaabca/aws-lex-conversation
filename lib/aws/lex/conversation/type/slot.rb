# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Slot
          include Base

          required :shape, default: -> { 'Scalar' }
          optional :name, virtual: true
          required :lex_value, from: :value, default: -> { {} }, virtual: true
          required :lex_values, from: :values, default: -> { [] }, virtual: true
          required :active, default: -> { false }, virtual: true

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

          # takes an array of slot values
          def values=(vals)
            return if shape.scalar?

            self.lex_values = vals.map do |val|
              Slot.shrink_wrap(
                active: true,
                value: {
                  interpretedValue: val,
                  originalValue: val,
                  resolvedValues: [val]
                }
              )
            end
          end

          def values
            lex_values.map(&:value)
          end

          def active?
            @active
          end

          def filled?
            shape.list? ? values.any? : value != '' && !value.nil?
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
