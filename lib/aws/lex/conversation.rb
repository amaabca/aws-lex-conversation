# frozen_string_literal: true

require_relative 'conversation/base'

module Aws
  module Lex
    class Conversation
      extend Forwardable
      include Support::Mixins::Responses

      attr_accessor :event, :context, :lex

      def_delegators :@lex, :proposed_next_state, :transcriptions

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
        lex.session_state.session_attributes
      end

      def checkpoint!(opts = {})
        label = opts.fetch(:label)
        params = {
          label: label,
          dialog_action_type: opts.fetch(:dialog_action_type) { 'Delegate' },
          fulfillment_state: opts[:fulfillment_state],
          intent: opts.fetch(:intent) { lex.current_intent },
          slot_to_elicit: opts[:slot_to_elicit]
        }.compact

        if checkpoint?(label: label)
          # update the existing checkpoint
          checkpoint(label: label).assign_attributes!(params)
        else
          checkpoints.unshift(
            Type::Checkpoint.build(params)
          )
        end
      end

      def checkpoint?(label:)
        !checkpoint(label: label).nil?
      end

      def checkpoint(label:)
        checkpoints.find { |v| v.label == label }
      end

      def checkpoints
        lex.session_state.session_attributes.checkpoints
      end

      def restore_from!(checkpoint)
        # we're done with the stored checkpoint once it's been restored
        checkpoints.delete_if { |c| c.label == checkpoint.label }
        # remove any memoized intent data
        lex.current_intent = nil
        # replace the intent with data from the checkpoint
        lex.session_state.intent = checkpoint.intent
        dialog_action = Type::DialogAction.new(
          type: checkpoint.dialog_action_type,
          slot_to_elicit: checkpoint.slot_to_elicit
        )
        lex.session_state.dialog_action = dialog_action
        self
      end

      def active_context?(name:)
        !active_context(name: name).nil?
      end

      def active_context(name:)
        lex.session_state.active_contexts.find { |c| c.name == name }
      end

      def active_context!(name:, turns: 10, seconds: 300, attributes: {})
        # look for an existing active context if present
        instance = active_context(name: name)

        if instance
          clear_context!(name: name)
        else
          instance = Type::Context.new
        end

        # update attributes as requested
        instance.name = name
        instance.context_attributes = attributes
        instance.time_to_live = Type::TimeToLive.new(
          turns_to_live: turns,
          time_to_live_in_seconds: seconds
        )
        lex.session_state.active_contexts << instance
        instance
      end

      def clear_context!(name:)
        lex.session_state.active_contexts.delete_if { |c| c.name == name }
      end

      def clear_all_contexts!
        lex.session_state.active_contexts = []
      end

      def proposed_next_state?
        !proposed_next_state.nil?
      end

      def stash
        @stash ||= {}
      end
    end
  end
end
