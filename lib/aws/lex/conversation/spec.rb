require_relative 'spec/matchers'
require_relative 'simulator'

module Aws
  module Lex
    class Conversation
      module Spec
        def self.included(base)
          base.include(Matchers)
        end
      end
    end
  end
end
