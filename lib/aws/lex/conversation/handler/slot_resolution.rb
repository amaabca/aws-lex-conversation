# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Handler
        class SlotResolution < Base
          def will_respond?(conversation)
            # respond by default unless told otherwise
            callable = options.fetch(:respond_on) { ->(_c) { true } }
            callable.call(conversation)
          end

          def response(conversation)
            # resolve all slots to their top resolution
            conversation.slots.values.each(&:resolve!)

            unless successor
              msg = 'Handler `SlotResolution` must not be the final handler in the chain'
              raise Exception::MissingHandler, msg
            end

            # call the next handler in the chain
            successor.handle(conversation)
          end
        end
      end
    end
  end
end
