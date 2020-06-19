module Aws
  module Lex
    class Conversation
      module Type
        class Event
          include Base

          required :current_intent
          required :bot
          required :user_id
          required :input_transcript
          required :invocation_source
          required :output_dialog_mode
          required :message_version
          required :session_attributes
          required :recent_intent_summary_view
          optional :request_attributes
          optional :sentiment_response
          optional :kendra_response

          coerce(
            current_intent: CurrentIntent,
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
