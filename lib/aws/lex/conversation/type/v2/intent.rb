# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Intent
          include Base

          required :name
          required :raw_slots, from: :slots, virtual: true
          required :confirmation_status, from: :confirmation_state
          required :state
          optional :nlu_intent_confidence_score

          computed_property :slots, ->(instance) do
            # any keys indexed without a value will return an empty Slot instance
            default_hash = Hash.new do |_hash, key|
              Slot.new(active: false, name: key.to_sym, value: nil, current_intent: instance)
            end

            instance.raw_slots.each_with_object(default_hash) do |(key, value), hash|
              hash[key.to_sym] = Slot.shrink_wrap(
                active: true,
                name: key,
                value: value,
                # pass a reference to the parent down to the slot so that each slot
                # instance can view a broader scope such as slot_details/resolutions
                current_intent: instance
              )
            end
          end

          "slots": {
            "VehicleModel": {
              "value": {
                "originalValue": "maxima",
                "resolvedValues": [
                  "MAXIMA"
                ],
                "interpretedValue": "MAXIMA"
              }
            },
            "VehicleMake": {
              "value": {
                "originalValue": "nissan",
                "resolvedValues": [
                  "NISSAN"
                ],
                "interpretedValue": "NISSAN"
              }
            },
            "VehicleColor": null,
            "VehicleYear": null
          },
          "confirmationState": "None",
          "name": "Lex_Intent_MadMaxV2VehicleQuery",
          "state": "InProgress"

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
