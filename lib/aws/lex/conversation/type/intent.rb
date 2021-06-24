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

          computed_property :slots, ->(instance) do
            # any keys indexed without a value will return an empty Slot instance
            default_hash = Hash.new do |_hash, key|
              Slot.new(active: false, name: key.to_sym, value: nil)
            end

            instance.raw_slots.each_with_object(default_hash) do |(key, value), hash|
              # require 'pry'; binding.pry
              hash[key.to_sym] = Slot.shrink_wrap(
                active: true,
                name: key,
                shape: value[:shape],
                value: value[:value],
                values: value[:values]
              )
            end
          end

          coerce(
            raw_slots: symbolize_hash!,
            confirmation_state: ConfirmationState
          )
        end
      end
    end
  end
end
