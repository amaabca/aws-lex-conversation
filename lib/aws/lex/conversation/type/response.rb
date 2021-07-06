# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Response
          include Base

          required :session_state
          required :messages
          required :request_attributes
        end
      end
    end
  end
end
