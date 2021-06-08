# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Handler
        module V1
          class Delegate < Base
            def response(conversation)
              conversation.delegate(
                slots: conversation.lex.current_intent.slots
              )
            end
          end
        end
      end
    end
  end
end
