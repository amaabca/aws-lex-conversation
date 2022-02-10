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
            resolved_slots: Array[Slot]
          )
        end
      end
    end
  end
end
