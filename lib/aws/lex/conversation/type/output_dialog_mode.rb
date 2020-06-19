module Aws
  module Lex
    class Conversation
      module Type
        class OutputDialogMode
          include Enumeration

          enumeration('Voice')
          enumeration('Text')
        end
      end
    end
  end
end
