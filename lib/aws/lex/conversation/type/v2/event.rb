# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        module V2
          class Event
            include Base

            required :bot
            required :user_id, from: :session_id
            required :input_transcript
            required :interpretations, default: -> { [] }
            required :invocation_source
            required :message_version
            required :request_attributes, default: -> { {} }
            required :session_state, default: -> { {} }

            computed_property :current_intent, ->(instance) do
              instance.session_state.intent # TODO: might want to pull it from interpretations based on session_state.intent.name
            end

            computed_property :intents, ->(instance) do
              instance.interpretations
            end

            # any keys indexed without a value will return an empty Slot instance
            default_hash = Hash.new do |_hash, key|
              Slot.new(active: false, name: key.to_sym, value: nil, current_intent: instance)
            end

            instance.raw_slots.each_with_object(default_hash) do |(key, value), hash|
              hash[key.to_sym] = Slot.shrink_wrap(
                active: true,
                name: key,
                value: value,
                # pass a reference to the parent down to the slot so that each slot
                # instance can view a broader scope such as slot_details/resolutions
                current_intent: instance
              )
            end

            computed_property :kendra_response, ->(instance) do
              instance.current_intent.kendra_response
            end

            computed_property :sentiment_response, ->(instance) do
              instance.current_intent.sentiment_response
            end

            computed_property :session_attributes, ->(instance) do
              instance.session_state.session_attributes
            end

            computed_property :active_contexts, ->(instance) do
              instance.session_state.active_contexts
            end

            coerce(
              bot: Bot,
              interpretations: Array[Interpretation]
              invocation_source: InvocationSource,
              request_attributes: symbolize_hash!,
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
