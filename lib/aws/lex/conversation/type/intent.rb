# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Intent
          include Base

          required :confirmation_state
          optional :kendra_response
          required :name
          required :raw_slots, from: :slots, virtual: true
          required :state
          optional :originating_request_id
          optional :nlu_confidence

          computed_property(:slots) do |instance|
            # any keys indexed without a value will return an empty Slot instance
            default_hash = Hash.new do |_hash, key|
              Slot.shrink_wrap(active: false, name: key.to_sym, value: nil, shape: 'Scalar')
            end

            instance.raw_slots.each_with_object(default_hash) do |(key, value), hash|
              normalized = value&.transform_keys(&:to_sym) || { shape: 'Scalar' }
              hash[key.to_sym] = Slot.shrink_wrap(
                active: true,
                name: key,
                shape: normalized[:shape],
                value: normalized[:value],
                values: normalized[:values]
              )
            end
          end

          coerce(
            raw_slots: symbolize_hash!,
            slots: Array[Slot],
            confirmation_state: ConfirmationState,
            nlu_confidence: float!(nilable: true)
          )
        end
      end
    end
  end
end
