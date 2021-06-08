# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          class ResponseCard
            include Base

            optional :version
            optional :content_type, default: 'application/vnd.amazonaws.card.generic'
            required :generic_attachments

            coerce(
              version: integer!,
              content_type: ResponseCard::ContentType,
              generic_attachments: Array[GenericAttachment]
            )
          end
        end
      end
    end
  end
end
