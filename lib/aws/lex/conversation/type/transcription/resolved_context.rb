# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Transcription
          class ResolvedContext
            include Base

            optional :intent
          end
        end
      end
    end
  end
end
