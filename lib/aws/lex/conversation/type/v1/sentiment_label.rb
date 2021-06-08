# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          class SentimentLabel
            include Enumeration

            enumeration('POSITIVE')
            enumeration('MIXED')
            enumeration('NEUTRAL')
            enumeration('NEGATIVE')
          end
        end
      end
    end
  end
end
