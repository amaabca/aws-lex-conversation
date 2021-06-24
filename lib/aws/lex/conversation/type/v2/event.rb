# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V2
          class Event
            include Base

            required :bot
            required :session_id
            required :input_transcript
            required :interpretations, default: -> { [] }
            required :invocation_source
            required :message_version
            required :request_attributes, default: -> { {} }
            required :session_state, default: -> { {} }
            required :input_mode

            # computed :user_id, ->(instance) do
            #   instance.session_id
            # end

            # computed_property :intents, ->(instance) do
            #   instance.interpretations.map(&:intent)
            # end

            # computed_property :current_intent, ->(instance) do
            #   instance.intents.find { |intent| intent.name == instance.session_state.intent.name }
            # end

            # computed_property :kendra_response, ->(instance) do
            #   instance.current_intent.kendra_response
            # end

            # computed_property :sentiment_response, ->(instance) do
            #   instance.current_intent.sentiment_response
            # end

            # computed_property :session_attributes, ->(instance) do
            #   instance.session_state.session_attributes
            # end

            # computed_property :active_contexts, ->(instance) do
            #   instance.session_state.active_contexts
            # end

            coerce(
              bot: Bot,
              input_mode: InputMode,
              interpretations: Array[Interpretation],
              invocation_source: InvocationSource,
              request_attributes: symbolize_hash!,
              response_content_type: ResponseContentType,
              sentiment_response: SentimentResponse,
              session_state: SessionState
            )

            def recent_intent_summary_view
              []
            end
          end
        end
      end
    end
  end
end
