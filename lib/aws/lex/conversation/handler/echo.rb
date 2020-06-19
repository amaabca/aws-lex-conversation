# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Handler
        class Echo < Base
          def will_handle?(_conversation)
            true
          end

          def response(conversation)
            {
              dialogAction: {
                type: 'Close',
                fulfillmentState: 'Fulfilled',
                message: {
                  contentType: 'PlainText',
                  content: conversation.event['inputTranscript'].to_s
                }
              }
            }
          end
        end
      end
    end
  end
end
