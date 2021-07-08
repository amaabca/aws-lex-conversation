# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Message
          include Base

          required :content_type, default: -> { 'PlainText' }
          required :content
          optional :image_response_card

          coerce(
            content_type: Message::ContentType,
            image_response_card: Aws::Lex::Conversation::Type::ResponseCard
          )
        end
      end
    end
  end
end
