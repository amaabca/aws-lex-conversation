# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      class Simulator
        attr_accessor :lex

        def initialize(opts = {})
          self.lex = opts.fetch(:lex) do
            Type::Event.shrink_wrap(
              bot: default_bot,
              inputMode: 'Text',
              inputTranscript: '',
              interpretations: [],
              invocationSource: 'DialogCodeHook',
              messageVersion: '1.0',
              requestAttributes: {},
              responseContentType: 'text/plain; charset=utf-8',
              sessionId: '1234567890000',
              sessionState: default_session_state
            )
          end
          interpretation(name: 'SIMULATION')
        end

        def event
          lex.to_lex
        end

        def bot(opts = {})
          changes = {
            aliasName: opts[:alias_name],
            aliasId: opts[:alias_id],
            name: opts[:name],
            version: opts[:version],
            localeId: opts[:locale_id],
            id: opts[:id]
          }.compact
          lex.bot = Type::Bot.shrink_wrap(lex.bot.to_lex.merge(changes))
          self
        end

        def transcript(message)
          lex.input_transcript = message
          self
        end

        def intent(opts = {})
          data = default_intent(opts)
          intent = Type::Intent.shrink_wrap(data)
          lex.session_state.intent = intent
          interpretation(data)
        end

        # rubocop:disable Metrics/AbcSize
        def interpretation(opts = {})
          name = opts.fetch(:name)
          slots = opts.fetch(:slots) { {} }
          sentiment_score = opts.dig(:sentiment_response, :sentiment_score)
          sentiment = opts.dig(:sentiment_response, :sentiment)
          sentiment_response = opts[:sentiment_response] && {
            sentiment: sentiment,
            sentimentScore: sentiment_score
          }
          data = {
            intent: default_intent(opts),
            sentimentResponse: sentiment_response,
            nluConfidence: opts[:nlu_confidence]
          }.compact
          lex.interpretations.delete_if { |i| i.intent.name == name }
          lex.interpretations << Type::Interpretation.shrink_wrap(data)
          slots.each do |key, value|
            slot_data = { name: key }.merge(value)
            slot(slot_data)
          end
          reset_computed_properties!
          self
        end
        # rubocop:enable Metrics/AbcSize

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
          name = opts.fetch(:name).to_sym
          raw_slots = {
            shape: opts.fetch(:shape) { 'Scalar' },
            value: {
              originalValue: opts.fetch(:original_value) { opts.fetch(:value) },
              resolvedValues: opts.fetch(:resolved_values) { [opts.fetch(:value)] },
              interpretedValue: opts.fetch(:interpreted_value) { opts.fetch(:value) }
            }
          }
          lex.session_state.intent.raw_slots[name] = raw_slots
          current_interpretation.intent.raw_slots[name] = raw_slots
          reset_computed_properties!
          self
        end

        def invocation_source(source)
          lex.invocation_source = Type::InvocationSource.new(source)
          self
        end

        def input_mode(mode)
          lex.input_mode = Type::InputMode.new(mode)
          self
        end

        def session(data)
          lex.session_state.session_attributes.merge!(Type::SessionAttributes[data])
          self
        end

        private

        def current_interpretation
          lex.interpretations.find { |i| i.intent.name == lex.session_state.intent.name }
        end

        # computed properties are memoized using instance variables, so we must
        # uncache the values when things change
        def reset_computed_properties!
          %w[
            @alternate_intents
            @current_intent
            @intents
          ].each do |variable|
            lex.instance_variable_set(variable, nil)
          end

          lex.session_state.intent.instance_variable_set('@slots', nil)
          current_interpretation.intent.instance_variable_set('@slots', nil)
        end

        def default_bot
          {
            aliasId: 'TSTALIASID',
            aliasName: 'TestBotAlias',
            id: 'BOT_ID',
            localeId: 'en_US',
            name: 'SIMULATOR',
            version: 'DRAFT'
          }
        end

        def default_session_state
          {
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
        end

        def default_intent(opts = {})
          {
            confirmationState: opts.fetch(:confirmation_state) { 'None' },
            kendraResponse: opts[:kendra_response],
            name: opts.fetch(:name),
            nluConfidence: opts[:nlu_confidence],
            originatingRequestId: opts.fetch(:originating_request_id) { SecureRandom.uuid },
            slots: opts.fetch(:slots) { {} },
            state: opts.fetch(:state) { 'InProgress' }
          }.compact
        end
      end
    end
  end
end
