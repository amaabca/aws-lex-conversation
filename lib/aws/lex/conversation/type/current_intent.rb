# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class CurrentIntent
          include Base

          required :name
          required :raw_slots, from: :slots, virtual: true
          required :slot_details
          required :confirmation_status

          computed_property :slots, ->(instance) do
            instance.raw_slots.each_with_object({}) do |(key, value), hash|
              hash[key.to_sym] = Slot.shrink_wrap(
                name: key,
                value: value,
                # pass a reference to the parent down to the slot so that each slot
                # instance can view a broader scope such as slot_details/resolutions
                current_intent: instance
              )
            end
          end

          class << self
            def slot_details!
              ->(v) do
                v.each_with_object({}) do |(key, value), hash|
                  hash[key.to_sym] = SlotDetail.shrink_wrap(value)
                end
              end
            end
          end

          coerce(
            slot_details: slot_details!,
            confirmation_status: ConfirmationStatus
          )
        end
      end
    end
  end
end
