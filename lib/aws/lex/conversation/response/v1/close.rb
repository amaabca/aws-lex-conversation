# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Response
        module V1
          class Close < Base
            attr_accessor :fulfillment_state, :message, :response_card

            def initialize(opts = {})
              super
              self.fulfillment_state = opts.fetch(:fulfillment_state)
              self.message = opts[:message]
              self.response_card = opts[:response_card]
            end

            def dialog_action
              {
                type: 'Close',
                fulfillmentState: fulfillment_state,
                message: message,
                responseCard: response_card
              }.compact
            end
          end
        end
      end
    end
  end
end
