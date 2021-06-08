# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          class Bot
            include Base

            required :name
            required :alias
            required :version
          end
        end
      end
    end
  end
end
