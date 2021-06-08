# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          class FulfillmentState
            include Enumeration

            enumeration('Fulfilled')
            enumeration('Failed')
          end
        end
      end
    end
  end
end
