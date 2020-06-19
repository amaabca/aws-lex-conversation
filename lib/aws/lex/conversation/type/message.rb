module Aws
  module Lex
    class Conversation
      module Type
        class Message
          include Base
          
          optional :content_type, default: 'PlainText'
          required :content

          coerce(
            content_type: Message::ContentType
          )
        end
      end
    end
  end
end
