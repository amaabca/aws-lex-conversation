# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Response
        class ElicitSlot < Base
          attr_accessor :slot_to_elicit

          def initialize(opts = {})
            super
            self.slot_to_elicit = opts.fetch(:slot_to_elicit)
            session_state.dialog_action = dialog_action
          end

          def dialog_action
            Aws::Lex::Conversation::Type::DialogAction.shrink_wrap(
              type: 'ElicitSlot',
              slotToElicit: slot_to_elicit
            )
          end
        end
      end
    end
  end
end
