# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Handler
        class Echo < Base
          def response(conversation)
            content = options.fetch(:content) { conversation.lex.input_transcript }
            content_type = options.fetch(:content_type) { Type::Message::ContentType.new('PlainText') }
            fulfillment_state = options.fetch(:fulfillment_state) { Type::FulfillmentState.new('Fulfilled') }
            conversation.close(
              fulfillment_state: fulfillment_state,
              messages: [
                Type::Message.new(
                  content: content,
                  content_type: content_type
                )
              ]
            )
          end
        end
      end
    end
  end
end
