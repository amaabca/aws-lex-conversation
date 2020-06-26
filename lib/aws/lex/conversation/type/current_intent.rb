# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class CurrentIntent
          include Base

          required :name
          required :slots
          required :slot_details
          required :confirmation_status

          class << self
            def slots!
              ->(v) do
                v.each_with_object({}) do |(key, value), hash|
                  hash[key.to_sym] = Slot.shrink_wrap(
                    name: key,
                    value: value
                  )
                end
              end
            end

            def slot_details!
              ->(v) do
                v.each_with_object({}) do |(key, value), hash|
                  hash[key.to_sym] = SlotDetail.shrink_wrap(value)
                end
              end
            end
          end

          coerce(
            slots: slots!,
            slot_details: slot_details!,
            confirmation_status: ConfirmationStatus
          )
        end
      end
    end
  end
end
