# frozen_string_literal: true

module Aws
  module Lex
    class Conversation
      module Type
        class Checkpoint
          include Base

          required :dialog_action_type
          required :intent

          optional :label
          optional :fulfillment_state
          optional :slot_to_elicit

          coerce(
            intent: Intent,
            dialog_action_type: DialogActionType,
            fulfillment_state: FulfillmentState
          )

          class << self
            def build(opts = {})
              new(normalize_parameters(opts))
            end

            private

            def normalize_parameters(opts)
              params = opts.dup # we don't want to mutate our arguments

              if params[:dialog_action_type].is_a?(String)
                params[:dialog_action_type] = DialogActionType.new(params[:dialog_action_type])
              end

              if params[:fulfillment_state].is_a?(String)
                params[:fulfillment_state] = FulfillmentState.new(params[:fulfillment_state])
              end

              params
            end
          end

          # restore the checkpoint AND remove it from session
          def restore!(conversation, opts = {})
            conversation.checkpoints.delete_if { |c| c.label == label }
            restore(conversation, opts)
          end

          # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          def restore(conversation, opts = {})
            case dialog_action_type.raw
            when 'Close'
              conversation.close(
                intent: intent,
                fulfillment_state: opts.fetch(:fulfillment_state) { fulfillment_state },
                messages: opts.fetch(:messages)
              )
            when 'ConfirmIntent'
              conversation.confirm_intent(
                intent: intent,
                messages: opts.fetch(:messages)
              )
            when 'Delegate'
              conversation.delegate(
                intent: intent
              )
            when 'ElicitIntent'
              conversation.elicit_intent(
                intent: intent,
                messages: opts.fetch(:messages)
              )
            when 'ElicitSlot'
              conversation.elicit_slot(
                intent: intent,
                messages: opts.fetch(:messages),
                slot_to_elicit: slot_to_elicit
              )
            else
              raise ArgumentError, "invalid DialogActionType: `#{dialog_action_type.raw}`"
            end
          end
          # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
        end
      end
    end
  end
end
