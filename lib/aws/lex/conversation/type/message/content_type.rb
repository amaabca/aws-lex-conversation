# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Message
          class ContentType
            include Enumeration

            enumeration('CustomPayload')
            enumeration('ImageResponseCard')
            enumeration('PlainText')
            enumeration('SSML')
          end
        end
      end
    end
  end
end
