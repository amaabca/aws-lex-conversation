module Aws
  module Lex
    class Conversation
      module Transformer
        class V1ToV2 < Shrink::Wrap::Transformer::Base
          def transform(input)
            lex = options.fetch(:lex)
            raw_slots = input.dig(:dialogAction, :slots) || lex.current_intent.raw_slots
            slots = raw_slots.each_with_object({}) do |(key, value), hash|
              name = key.to_sym
              slot = lex.current_intent.slots[name]

              if slot.filled?
                hash[name] = {
                  value: {
                    interpretedValue: slot.value,
                    originalValue: slot.original_value,
                    resolvedValues: slot.details.resolutions.map(&:value)
                  }
                }
              elsif value
                hash[name] = {
                  value: {
                    interpretedValue: value,
                    originalValue: value,
                    resolvedValues: [value]
                  }
                }
              else
                hash[name] = nil
              end
            end

            message = input.dig(:dialogAction, :message)
            messages = message ? [message] : []
            encoded_checkpoints = if input[:recentIntentSummaryView]
                                    json = input[:recentIntentSummaryView].to_json
                                    Base64.urlsafe_encode64(json, padding: false)
                                  else
                                    lex.session[:checkpoints]
                                  end

            session = (input[:sessionAttributes] || {})
              .merge(checkpoints: encoded_checkpoints)
              .compact

            {
              sessionState: {
                activeContexts: [],
                sessionAttributes: session,
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
              requestAttributes: {}
            }
          end
        end
      end
    end
  end
end
