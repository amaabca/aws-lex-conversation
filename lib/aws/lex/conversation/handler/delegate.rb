# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Handler
        class Delegate < Base
          def response(conversation)
            conversation.delegate(
              slots: conversation.current_intent.slots
            )
          end
        end
      end
    end
  end
end
