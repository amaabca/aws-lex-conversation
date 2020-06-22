# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Response
        class ElicitSlot < Base
          attr_accessor :intent_name, :message, :response_card, :slots, :slot_to_elicit

          def initialize(opts = {})
            super
            self.intent_name = opts.fetch(:intent_name)
            self.slot_to_elicit = opts.fetch(:slot_to_elicit)
            self.slots = opts.fetch(:slots)
            self.message = opts[:message]
            self.response_card = opts[:response_card]
          end

          def dialog_action
            {
              type: 'ElicitSlot',
              intentName: intent_name,
              slots: slots,
              slotToElicit: slot_to_elicit,
              message: message,
              responseCard: response_card
            }.reject { |_, v| v.nil? }
          end
        end
      end
    end
  end
end
