# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          class InvocationSource
            include Enumeration

            enumeration('DialogCodeHook')
            enumeration('FulfillmentCodeHook')
          end
        end
      end
    end
  end
end
