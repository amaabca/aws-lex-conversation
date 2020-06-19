module Aws
  module Lex
    class Conversation
      module Type
        class FulfillmentState
          include Enumeration

          enumeration('Fulfilled')
          enumeration('Failed')
        end
      end
    end
  end
end
