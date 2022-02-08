# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Transcription
          class ResolvedContext
            include Base

            required :intent
          end
        end
      end
    end
  end
end
