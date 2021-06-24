# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class SentimentScore
          include Base

          required :mixed
          required :negative
          required :neutral
          required :positive

          coerce(
            mixed: float!(nilable: true),
            negative: float!(nilable: true),
            neutral: float!(nilable: true),
            positive: float!(nilable: true)
          )
        end
      end
    end
  end
end
