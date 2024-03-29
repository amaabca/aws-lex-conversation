# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Sentiment
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
