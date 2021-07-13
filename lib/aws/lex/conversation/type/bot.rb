# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Bot
          include Base

          required :alias_id
          required :id
          required :locale_id
          required :name
          required :version
        end
      end
    end
  end
end
