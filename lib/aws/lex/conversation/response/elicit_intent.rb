# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Response
        class ElicitIntent < Base
          attr_accessor :message, :response_card

          def initialize(opts = {})
            super
            session_state.dialog_action = dialog_action
            # by default, we set intent as nil unless overridden
            session_state.intent = opts[:intent]
          end

          def dialog_action
            Aws::Lex::Conversation::Type::DialogAction.shrink_wrap(
              type: 'ElicitIntent'
            )
          end
        end
      end
    end
  end
end
