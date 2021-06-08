# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V1
          class Event
            include Base

            required :active_contexts, default: -> { [] }
            required :alternative_intents, default: -> { [] }
            required :current_intent
            required :bot
            required :user_id
            required :input_transcript
            required :invocation_source
            required :output_dialog_mode
            required :message_version
            required :session_attributes, default: -> { {} }
            required :recent_intent_summary_view, default: -> { [] }
            required :request_attributes, default: -> { {} }
            optional :sentiment_response
            optional :kendra_response

            computed_property :intents, ->(instance) do
              [instance.current_intent] | instance.alternative_intents
            end

            coerce(
              active_contexts: Array[Context],
              alternative_intents: Array[Intent],
              current_intent: Intent,
              bot: Bot,
              invocation_source: InvocationSource,
              output_dialog_mode: OutputDialogMode,
              session_attributes: symbolize_hash!,
              request_attributes: symbolize_hash!,
              recent_intent_summary_view: Array[RecentIntentSummaryView],
              sentiment_response: SentimentResponse
            )
          end
        end
      end
    end
  end
end
