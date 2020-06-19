module Aws
  module Lex
    class Conversation
      module Type
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
