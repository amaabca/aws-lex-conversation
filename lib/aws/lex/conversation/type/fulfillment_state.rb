# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class FulfillmentState
          include Enumeration

          enumeration('Fulfilled')
          enumeration('Failed')
          enumeration('InProgress')
          enumeration('ReadyForFulfillment')
        end
      end
    end
  end
end
