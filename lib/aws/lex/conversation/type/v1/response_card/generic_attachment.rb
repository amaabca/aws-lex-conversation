# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          class ResponseCard
            class GenericAttachment
              include Base

              required :title
              required :buttons

              optional :sub_title
              optional :image_url
              optional :attachment_link_url

              coerce(
                buttons: Array[Button]
              )
            end
          end
        end
      end
    end
  end
end
