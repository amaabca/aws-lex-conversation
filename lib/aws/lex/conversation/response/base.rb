module Aws
  module Lex
    class Conversation
      module Response
        class Base
          attr_accessor :session_attributes, :recent_intent_summary_view

          def initialize(opts = {})
            self.session_attributes = opts[:session_attributes]
            self.recent_intent_summary_view = opts[:recent_intent_summary_view]
          end

          def dialog_action
            raise ArgumentError, 'define dialog_action in a subclass'
          end

          def to_lex
            Type::Response.new(
              session_attributes: session_attributes,
              recent_intent_summary_view: recent_intent_summary_view,
              dialog_action: dialog_action
            ).to_lex
          end
        end
      end
    end
  end
end
