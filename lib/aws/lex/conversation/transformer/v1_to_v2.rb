module Aws
  module Lex
    class Conversation
      module Transformer
        class V1ToV2 < Shrink::Wrap::Transformer::Base
          def transform(input)
            lex = options.fetch(:lex)
            slots = lex.current_intent.slots.each_with_object({}) do |(key, value), hash|
              if value.filled?
                hash[key] = {
                  value: {
                    interpretedValue: value.value,
                    originalValue: value.original_value,
                    resolvedValues: value.details.resolutions.map(&:value)
                  }
                }
              else
                hash[key] = nil
              end
            end

            message = input.dig(:dialogAction, :message)
            messages = message ? [message] : []

            {
              sessionState: {
                activeContexts: [],
                sessionAttributes: input[:sessionAttributes] || {},
                dialogAction: {
                  slotToElicit: input.dig(:dialogAction, :slotToElicit),
                  type: input.dig(:dialogAction, :type)
                }.compact,
                intent: {
                  confirmationState: lex.current_intent.confirmation_status.raw,
                  name: input.dig(:dialogAction, :intentName) || lex.current_intent.name,
                  slots: slots,
                  state: input.dig(:dialogAction, :fulfillmentState) || 'InProgress'
                }.compact
              },
              messages: messages,
              requestAttributes:{}
            }
          end
        end
      end
    end
  end
end
