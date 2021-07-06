# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Event
          include Base

          required :bot
          required :input_mode
          required :input_transcript
          required :interpretations
          required :invocation_source
          required :message_version
          required :request_attributes
          required :response_content_type
          required :session_id
          required :session_state

          # TODO: do I want this?
          computed_property :current_intent, ->(instance) do
            instance.session_state.intent
          end

          computed_property :intents, ->(instance) do
            instance.map(&:interpretations).map(&:intent)
          end

          computed_property :alternate_intents, ->(instance) do
            instance.intents.reject { |intent| intent.name == current_intent.name }
          end

          coerce(
            bot: Bot,
            input_mode: InputMode,
            interpretations: Array[Interpretation],
            invocation_source: InvocationSource,
            request_attributes: symbolize_hash!,
            response_content_type: ResponseContentType,
            session_state: SessionState
          )
        end
      end
    end
  end
end
