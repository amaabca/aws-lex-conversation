module Aws
  module Lex
    class Conversation
      module Type
        class ResponseCard
          class ContentType
            include Enumeration

            enumeration('PlainText')
            enumeration('SSML')
            enumeration('CustomPayload')
          end
        end
      end
    end
  end
end
