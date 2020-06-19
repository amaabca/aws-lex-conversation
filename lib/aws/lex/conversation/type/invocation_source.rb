module Aws
  module Lex
    class Conversation
      module Type
        class InvocationSource
          include Enumeration

          enumeration('DialogCodeHook')
          enumeration('FulfillmentCodeHook')
        end
      end
    end
  end
end
