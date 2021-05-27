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
          optional :active, virtual: true

          def as_json(_opts = {})
            to_lex
          end

          def to_lex
            value
          end

          def active?
            @active
          end

          def filled?
            value.to_s != ''
          end

          def blank?
            !filled?
          end

          def value=(other)
            @value = other
            current_intent.raw_slots[name] = @value
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

          def requestable?
            active? && blank?
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
