# frozen_string_literal: true

require_relative 'conversation/base'

module Aws
  module Lex
    class Conversation
      include Support::Mixins::Responses

      attr_accessor :event, :context, :lex

      def initialize(opts = {})
        self.event = opts.fetch(:event)
        self.context = opts.fetch(:context)
        self.lex = Type::Event.shrink_wrap(event)
      end

      def chain
        @chain ||= []
      end

      def handlers=(list)
        last = nil

        reversed = list.reverse.map do |element|
          handler = element.fetch(:handler).new(
            options: element.fetch(:options) { {} },
            successor: last
          )
          last = handler
          handler
        end

        @chain = reversed.reverse
      end

      def handlers
        chain.map(&:class)
      end

      def respond
        chain.first.handle(self)
      end

      def intent_confidence
        @intent_confidence ||= Type::IntentConfidence.new(event: lex)
      end

      def intent_name
        lex.current_intent.name
      end

      def slots
        lex.current_intent.slots
      end

      def session
        lex.session_attributes
      end

      def checkpoint!(opts = {})
        label = opts.fetch(:label)
        intent = opts.fetch(:intent_name) { intent_name }
        params = {
          checkpoint_label: label,
          confirmation_status: opts.fetch(:confirmation_status) { lex.current_intent.confirmation_status },
          dialog_action_type: opts.fetch(:dialog_action_type),
          fulfillment_state: opts[:fulfillment_state],
          intent_name: intent,
          slots: opts.fetch(:slots) { lex.current_intent.raw_slots },
          slot_to_elicit: opts[:slot_to_elicit]
        }.compact

        view = lex.recent_intent_summary_view.find { |v| v.intent_name == intent }

        if view
          view.assign_attributes!(params)
          view
        else
          lex.recent_intent_summary_view.unshift(Type::RecentIntentSummaryView.new(params))
        end
      end

      def checkpoint?(label:)
        lex.recent_intent_summary_view.any? { |v| v.checkpoint_label == label }
      end

      def checkpoint(label:)
        lex.recent_intent_summary_view.find { |v| v.checkpoint_label == label }
      end

      def stash
        @stash ||= {}
      end
    end
  end
end
