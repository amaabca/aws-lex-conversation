# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class ResponseCard
          include Base

          required :title
          required :buttons, default: -> { [] }
          optional :sub_title
          optional :image_url

          coerce(
            buttons: Array[ResponseCard::Button]
          )
        end
      end
    end
  end
end
