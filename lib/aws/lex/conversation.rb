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
        Transformer::V1ToV2.new(lex: lex).transform(chain.first.handle(self))
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

        # NOTE: this will only work for V2 right now...
        if checkpoint?(label: label)
          # update the existing checkpoint
          checkpoint(label: label).assign_attributes!(params)
        else
          checkpoints.unshift(
            Type::RecentIntentSummaryView.new(params)
          )
        end

        # write to session
        json = checkpoints.map { |c| c.to_lex }.to_json
        session[:checkpoints] = Base64.encode64(json)
      end
      # rubocop:enable Metrics/AbcSize

      def checkpoint?(label:)
        !checkpoint(label: label).nil?
      end

      def checkpoint(label:)
        checkpoints.find { |v| v.checkpoint_label == label }
      end

      def checkpoints
        stash[:checkpoints] ||= build_checkpoints_from_session!
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

      private

      def build_checkpoints_from_session!
        if session[:checkpoints].nil?
          []
        else
          JSON.parse(Base64.decode64(session[:checkpoints])).map do |checkpoint|
            Type::RecentIntentSummaryView.shrink_wrap(checkpoint)
          end
        end
      end
    end
  end
end
