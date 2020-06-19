# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Handler
        class Base
          attr_accessor :successor, :options

          def initialize(opts = {})
            self.successor = opts[:successor]
            self.options = opts[:options]
          end

          def will_handle?(_conversation)
            false
          end

          def response(_conversation)
            raise ArgumentError, 'define #response in a subclass'
          end

          def handle(conversation)
            return response(conversation) if will_handle?(conversation)
            return unless successor # end of chain - return nil

            successor.handle(conversation)
          end
        end
      end
    end
  end
end
