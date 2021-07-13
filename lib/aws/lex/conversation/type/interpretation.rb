# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Interpretation
          include Base

          required :intent
          optional :nlu_confidence
          optional :sentiment_response

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
