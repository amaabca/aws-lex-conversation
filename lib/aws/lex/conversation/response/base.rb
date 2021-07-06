# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Response
        class Base
          attr_accessor(
            :session_state,
            :messages,
            :request_attributes,
            :fulfillment_state
          )

          def initialize(opts = {})
            self.session_state = opts[:session_state]
            self.messages = opts[:messages]
            self.request_attributes = opts[:request_attributes]
            session_state.intent.state = opts.fetch(:fulfillment_state) { session_state.intent.state }
          end

          def dialog_action
            raise NotImplementedError, 'define dialog_action in a subclass'
          end

          def to_lex
            Type::Response.new(
              session_state: session_state,
              messages: messages,
              request_attributes: request_attributes
            ).to_lex
          end
        end
      end
    end
  end
end
