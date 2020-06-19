module Aws
  module Lex
    class Conversation
      module Type
        class ResponseCard
          include Base

          optional :version
          optional :content_type, default: 'application/vnd.amazonaws.card.generic'
          required :generic_attachments

          coerce(
            version: ->(v) { v.to_i },
            content_type: ResponseCard::ContentType,
            generic_attachments: Array[GenericAttachment]
          )
        end
      end
    end
  end
end
