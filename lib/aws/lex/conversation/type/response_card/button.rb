# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class ResponseCard
          class Button
            include Base

            required :text
            required :value
          end
        end
      end
    end
  end
end
