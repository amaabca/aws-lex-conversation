# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Slot
        module V1
          class Elicitor
            attr_accessor :conversation, :elicitations

            def initialize(opts = {})
              self.conversation = opts.fetch(:conversation)
              self.elicitations = opts.fetch(:elicitations) { [] }
              elicitations.each do |elicitation|
                elicitation.conversation = conversation
              end
            end

            def elicit?
              incomplete_elicitations.any?
            end

            def elicit!
              incomplete_elicitations.first.elicit! if elicit?
            end

            private

            def incomplete_elicitations
              elicitations.select(&:elicit?)
            end
          end
        end
      end
    end
  end
end
