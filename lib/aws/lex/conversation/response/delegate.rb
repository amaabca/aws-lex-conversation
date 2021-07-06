# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Response
        class Delegate < Base
          def initialize(opts = {})
            super
            session_state.dialog_action = dialog_action
          end

          def dialog_action
            Aws::Lex::Conversation::Type::DialogAction.shrink_wrap(
              type: 'Delegate'
            )
          end
        end
      end
    end
  end
end
