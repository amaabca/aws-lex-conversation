# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V2
          class SentimentResponse
            include Base

            required :sentiment
            required :sentiment_score

            computed_property :sentiment_label, ->(instance) do
              instance.sentiment
            end

            coerce(
              sentiment: SentimentLabel,
              sentiment_score: ->(v) { SentimentScore.parse_string(v) }
            )
          end
        end
      end
    end
  end
end
