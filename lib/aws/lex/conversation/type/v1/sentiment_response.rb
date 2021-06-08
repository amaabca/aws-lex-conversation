# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          class SentimentResponse
            include Base

            required :sentiment_label
            required :sentiment_score

            coerce(
              sentiment_label: SentimentLabel,
              sentiment_score: ->(v) { SentimentScore.parse_string(v) }
            )
          end
        end
      end
    end
  end
end
