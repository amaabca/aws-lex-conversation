# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Slot
          include Base

          required :current_intent, from: :current_intent, virtual: true
          required :name
          required :value

          def to_lex
            value
          end

          def filled?
            value.to_s != ''
          end

          def resolve!(index: 0)
            self.value = resolved(index: index)
          end

          def resolved(index: 0)
            details.resolutions.fetch(index) { SlotResolution.new(value: value) }.value
          end

          def original_value
            details.original_value
          end

          def resolvable?
            details.resolutions.any?
          end

          def details
            @details ||= current_intent.slot_details.fetch(name.to_sym) do
              SlotDetail.new(name: name, resolutions: [], original_value: value)
            end
          end
        end
      end
    end
  end
end
