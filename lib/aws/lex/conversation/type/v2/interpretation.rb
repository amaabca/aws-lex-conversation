# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V2
          class Interpretation
            include Base

            required :intent
            optional :nlu_confidence

            coerce(
              intent: Intent,
              nlu_confidence: float!(nilable: true)
            )
          end
        end
      end
    end
  end
end
