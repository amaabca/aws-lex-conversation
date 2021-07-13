# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Handler
        class Delegate < Base
          def response(conversation)
            conversation.delegate
          end
        end
      end
    end
  end
end
