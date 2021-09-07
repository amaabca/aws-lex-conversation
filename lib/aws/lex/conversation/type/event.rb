# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Event
          include Base

          required :bot
          required :input_mode
          required :input_transcript, default: -> { '' }
          required :interpretations
          required :invocation_source
          required :message_version
          required :request_attributes, default: -> { {} }
          required :response_content_type
          required :session_id
          required :session_state

          computed_property(:current_intent, virtual: true) do |instance|
            instance.session_state.intent.tap do |intent|
              intent.nlu_confidence = instance.interpretations.find { |i| i.intent.name == intent.name }&.nlu_confidence
            end
          end

          computed_property(:intents, virutal: true) do |instance|
            instance.interpretations.map(&:intent).tap do |intents|
              intents.map do |intent|
                intent.nlu_confidence = instance.interpretations.find { |i| i.intent.name == intent.name }&.nlu_confidence
              end
            end
          end

          computed_property(:alternate_intents, virtual: true) do |instance|
            instance.intents.reject { |intent| intent.name == instance.current_intent.name }
          end

          coerce(
            bot: Bot,
            input_mode: InputMode,
            interpretations: Array[Interpretation],
            invocation_source: InvocationSource,
            request_attributes: symbolize_hash!,
            response_content_type: Message::ContentType,
            session_state: SessionState
          )
        end
      end
    end
  end
end
