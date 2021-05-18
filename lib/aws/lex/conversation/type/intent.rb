# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Intent
          include Base

          required :name
          required :raw_slots, from: :slots, virtual: true
          required :slot_details
          required :confirmation_status
          optional :nlu_intent_confidence_score

          computed_property :slots, ->(instance) do
            # any keys indexed without a value will return an empty Slot instance
            default_hash = Hash.new do |_hash, key|
              Slot.new(name: key.to_sym, value: nil, current_intent: instance)
            end

            instance.raw_slots.each_with_object(default_hash) do |(key, value), hash|
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
              ->(val) do
                val
                  .compact
                  .each_with_object({}) do |(key, value), hash|
                    hash[key.to_sym] = SlotDetail.shrink_wrap(value)
                  end
              end
            end
          end

          coerce(
            slot_details: slot_details!,
            confirmation_status: ConfirmationStatus,
            nlu_intent_confidence_score: float!(nilable: true)
          )
        end
      end
    end
  end
end
