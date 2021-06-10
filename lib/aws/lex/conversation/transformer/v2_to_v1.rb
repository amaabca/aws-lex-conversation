module Aws
  module Lex
    class Conversation
      module Transformer
        class V2ToV1 < Shrink::Wrap::Transformer::Base
          def transform(input)
            intent_name = input.dig(:sessionState, :intent, :name)
            raw_slots = input.dig(:sessionState, :intent, :slots) || {}
            slots = raw_slots.each_with_object({}) do |(key, value), hash|
              hash[key] = value&.dig(:value, :interpretedValue)
            end
            slot_details = raw_slots.each_with_object({}) do |(key, value), hash|
              resolutions = value&.dig(:value, :resolvedValues).to_a

              hash[key] = {
                resolutions: resolutions.map { |r| { value: r } },
                originalValue: value&.dig(:value, :originalValue)
              }
            end
            encoded_checkpoints = input.dig(:sessionState, :sessionAttributes, :checkpoints)
            checkpoints = if encoded_checkpoints
                            JSON.parse(Base64.urlsafe_decode64(encoded_checkpoints), symbolize_names: true)
                          else
                            []
                          end

            {
              currentIntent: {
                name: intent_name,
                nluIntentConfidenceScore: input[:interpretations].find { |i| i.dig(:intent, :name) == intent_name }[:nluConfidence],
                slots: slots,
                slotDetails: slot_details,
                confirmationStatus: input.dig(:sessionState, :intent, :confirmationState)
              },
              alternativeIntents: [],
              bot: {
                name: input.dig(:bot, :name),
                alias: input.dig(:bot, :aliasName),
                version: input.dig(:bot, :version)
              },
              userId: input[:sessionId],
              messageVersion: '1.0',
              inputTranscript: input[:inputTranscript],
              invocationSource: input[:invocationSource],
              outputDialogMode: input[:inputMode],
              sessionAttributes: input.dig(:sessionState, :sessionAttributes) || {},
              requestAttributes: input[:requestAttributes] || {},
              recentIntentSummaryView: checkpoints,
              sentimentResponse: nil,
              kendraResponse: nil,
              activeContexts: []
            }
          end
        end
      end
    end
  end
end
