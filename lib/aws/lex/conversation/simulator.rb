module Aws
  module Lex
    class Conversation
      class Simulator
        attr_accessor :lex

        def initialize(opts = {})
          self.lex = opts.fetch(:lex) do
            Type::Event.shrink_wrap(
              bot: {
                aliasId: 'TSTALIASID',
                id: 'BOT_ID',
                localeId: 'en_US',
                name: 'SIMULATOR',
                version: 'DRAFT'
              },
              inputMode: 'Text',
              inputTranscript: '',
              interpretations: [],
              invocationSource: 'DialogCodeHook',
              messageVersion: '1.0',
              requestAttributes: {},
              responseContentType: 'text/plain; charset=utf-8',
              sessionId: '1234567890000',
              sessionState: {
                activeContexts: [],
                sessionAttributes: {},
                intent: {
                  confirmationState: 'None',
                  name: 'SIMULATION',
                  slots: {},
                  state: 'InProgress',
                  originatingRequestId: SecureRandom.uuid
                }
              }
            )
          end
        end

        def event
          lex.to_lex
        end

        def transcript(message)
          lex.input_transcript = message
          self
        end

        def intent(opts = {})
          data = default_intent_args(opts)
          intent = Type::Intent.shrink_wrap(data)
          lex.session_state.intent = intent
          interpretation(data)
        end

        def interpretation(opts = {})
          name = opts.fetch(:name)
          sentiment_score = opts.dig(:sentiment_response, :sentiment_score)
          sentiment = opts.dig(:sentiment_response, :sentiment)
          sentiment_response = opts[:sentiment_response] && {
            sentiment: sentiment,
            sentimentScore: sentiment_score
          }
          data = {
            intent: default_intent_args(opts),
            sentimentResponse: sentiment_response,
            nluConfidence: opts[:nlu_confidence]
          }.compact
          lex.interpretations.delete_if { |i| i.intent.name == name }
          lex.interpretations << Type::Interpretation.shrink_wrap(data)
          self
        end

        def context(opts = {})
          data = {
            name: opts.fetch(:name),
            contextAttributes: opts.fetch(:context_attributes) { {} },
            timeToLive: {
              timeToLiveInSeconds: opts.fetch(:seconds) { 600 },
              turnsToLive: opts.fetch(:turns) { 100 }
            }
          }
          context = Type::Context.shrink_wrap(data)
          lex.session_state.active_contexts.delete_if { |c| c.name == context.name }
          lex.session_state.active_contexts << context
          self
        end

        def slot(opts = {})
          # TODO: implement
          self
        end

        def invocation_source(source)
          lex.invocation_source = source
          self
        end

        private

        def default_intent_args(opts = {})
          {
            confirmationState: opts.fetch(:confirmation_state) { 'None' },
            name: opts.fetch(:name),
            slots: opts.fetch(:slots) { {} },
            state: opts.fetch(:state) { 'InProgress' },
            kendraResponse: opts[:kendra_response],
            originatingRequestId: opts.fetch(:originating_request_id) { SecureRandom.uuid },
            nluConfidence: opts[:nlu_confidence]
          }.compact
        end
      end
    end
  end
end
