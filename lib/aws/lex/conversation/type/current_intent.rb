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
            def slot_details!
              ->(v) do
                v.each_with_object({}) do |(key, value), hash|
                  hash[key.to_sym] = SlotDetail.shrink_wrap(value)
                end
              end
            end
          end

          coerce(
            slots: symbolize_hash!,
            slot_details: slot_details!,
            confirmation_status: ConfirmationStatus
          )
        end
      end
    end
  end
end
