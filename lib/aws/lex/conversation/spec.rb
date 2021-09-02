# frozen_string_literal: true

require 'rspec/expectations'
require_relative 'simulator'
require_relative 'spec/matchers'

module Aws
  module Lex
    class Conversation
      module Spec
        def self.included(base)
          base.include(Matchers)
        end
      end

      def simulate!
        @simulate ||= Simulator.new(lex: lex)
      end
    end
  end
end
