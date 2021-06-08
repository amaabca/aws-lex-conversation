# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V2
          class Response
            include Base

            required :session_state
            optional :messages
            optional :request_attributes
          end
        end
      end
    end
  end
end
