# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class SentimentResponse
          include Base

          required :sentiment
          required :sentiment_score

          coerce(
            sentiment_label: Sentiment,
            sentiment_score: SentimentScore
          )
        end
      end
    end
  end
end
