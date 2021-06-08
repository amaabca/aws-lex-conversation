# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          class ResponseCard
            class ContentType
              include Enumeration

              enumeration('application/vnd.amazonaws.card.generic')
            end
          end
        end
      end
    end
  end
end
