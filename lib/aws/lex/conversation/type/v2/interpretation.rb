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
            optional :sentiment_response

            computed_property :nlu_intent_confidence_score, ->(instance) do
              instance.nlu_confidence
            end

            computed_property :intent, ->(instance) do
              instance.nlu_confidence
            end

            coerce(
              intent: Intent,
              nlu_confidence: float!(nilable: true),
              sentiment_response: SentimentResponse
            )
          end
        end
      end
    end
  end
end
