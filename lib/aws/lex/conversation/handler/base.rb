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

          def will_respond?(conversation)
            callable = options.fetch(:respond_on) { ->(_c) { false } }
            callable.call(conversation)
          end

          def response(_conversation)
            raise NotImplementedError, 'define #response in a subclass'
          end

          def handle(conversation)
            return response(conversation) if will_respond?(conversation)
            return unless successor # end of chain - return nil

            successor.handle(conversation)
          end
        end
      end
    end
  end
end
