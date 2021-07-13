# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Response
        class Close < Base
          def initialize(opts = {})
            super
            session_state.dialog_action = dialog_action
            session_state.intent.state = opts.fetch(:fulfillment_state)
          end

          def dialog_action
            Aws::Lex::Conversation::Type::DialogAction.shrink_wrap(
              type: 'Close'
            )
          end
        end
      end
    end
  end
end
