# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Response
        class ConfirmIntent < Base
          attr_accessor :intent_name, :message, :response_card, :slots

          def initialize(opts = {})
            super
            self.intent_name = opts.fetch(:intent_name)
            self.slots = opts[:slots]
            self.message = opts[:message]
            self.response_card = opts[:response_card]
          end

          def dialog_action
            {
              type: 'ConfirmIntent',
              intentName: intent_name,
              slots: slots,
              message: message,
              responseCard: response_card
            }.reject { |_, v| v.nil? }
          end
        end
      end
    end
  end
end
