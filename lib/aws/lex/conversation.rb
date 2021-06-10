# frozen_string_literal: true

require_relative 'conversation/base'

module Aws
  module Lex
    class Conversation
      include Support::Mixins::Responses

      attr_accessor :event, :context, :lex, :translate_v2

      def initialize(opts = {})
        self.event = opts.fetch(:event)
        self.context = opts.fetch(:context)
        self.translate_v2 = opts.fetch(:translate_v2) { false }

        if translate_v2
          symbolized_event = Shrink::Wrap::Transformer::Symbolize.new(depth: 6).transform(event)
          transformed_event = Transformer::V2ToV1.new.transform(symbolized_event)
          self.lex = Type::Event.new(transformed_event)
        else
          self.lex = Type::Event.shrink_wrap(event)
        end
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
        if translate_v2
          Transformer::V1ToV2.new(lex: lex).transform(chain.first.handle(self))
        else
          chain.first.handle(self)
        end
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

      # rubocop:disable Metrics/AbcSize
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

        # flag that we need to send a new checkpoint back in the response
        stash[:checkpoint_pending] = true

        if checkpoint?(label: label)
          # update the existing checkpoint
          checkpoint(label: label).assign_attributes!(params)
        else
          lex.recent_intent_summary_view.unshift(
            Type::RecentIntentSummaryView.new(params)
          )
        end
      end
      # rubocop:enable Metrics/AbcSize

      def checkpoint?(label:)
        !checkpoint(label: label).nil?
      end

      def checkpoint(label:)
        lex.recent_intent_summary_view.find { |v| v.checkpoint_label == label }
      end

      # NOTE: lex responses should only include a recent_intent_summary_view
      # block if we want to change/add an existing checkpoint. If we don't
      # send a recent_intent_summary_view back in the response, lex retains
      # the previous intent history.
      def pending_checkpoints
        stash[:checkpoint_pending] && lex.recent_intent_summary_view
      end

      def stash
        @stash ||= {}
      end
    end
  end
end
