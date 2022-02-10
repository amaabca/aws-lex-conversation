# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Transcription
          include Base

          required :transcription
          required :transcription_confidence
          optional :resolved_context
          optional :resolved_slots
          alias_method :confidence, :transcription_confidence

          coerce(
            resolved_context: Transcription::ResolvedContext,
            resolved_slots: ->(slots) do
              slots.each_with_object({}) do |(name, data), hash|
                hash[name.to_sym] = Slot.shrink_wrap(data)
              end
            end
          )
        end
      end
    end
  end
end
